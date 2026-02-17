import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  // ---------------------------------------------------------------------------
  // CONFIGURAÇÃO
  // ---------------------------------------------------------------------------

  // Em Produção: NUNCA mantenha o Access Token no código cliente.
  // Mova isso para variáveis de ambiente (--dart-define) ou busque do seu backend.
  static const String _mpAccessToken = 'TEST-seu-access-token-aqui';

  static void initStripe(String publishableKey) {
    Stripe.publishableKey = publishableKey;
  }

  // Não precisamos mais de initMercadoPago com chave pública para esta abordagem
  // pois usaremos a API de Preferências (Checkout Pro) via HTTP.

  // ---------------------------------------------------------------------------
  // MERCADO PAGO (Integração via API REST - Sem SDK)
  // ---------------------------------------------------------------------------

  /// Cria uma preferência de pagamento e redireciona o usuário para o Checkout.
  ///
  /// Fluxo:
  /// 1. Monta o JSON da preferência.
  /// 2. Envia POST para a API do Mercado Pago (usando http ^1.x).
  /// 3. Recebe a URL de checkout (init_point).
  /// 4. Abre o navegador/webview para o usuário pagar.
  Future<bool> processMercadoPagoCheckout({
    required String title,
    required double amount,
    required String currencyId, // 'BRL'
    required String userEmail,
  }) async {
    final url = Uri.parse('https://api.mercadopago.com/checkout/preferences');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_mpAccessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "items": [
            {
              "title": title,
              "quantity": 1,
              "currency_id": currencyId,
              "unit_price": amount,
            }
          ],
          "payer": {"email": userEmail},
          // URLs para onde o usuário volta após pagar
          "back_urls": {
            "success": "https://ominiflow.app/success",
            "failure": "https://ominiflow.app/failure",
            "pending": "https://ominiflow.app/pending"
          },
          "auto_return": "approved",
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // init_point: URL para produção
        // sandbox_init_point: URL para testes
        final checkoutUrl = data['init_point'] as String;

        debugPrint('Preferência criada. Abrindo checkout: $checkoutUrl');

        // Abre o link no navegador (Chrome) ou Webview
        final uri = Uri.parse(checkoutUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri,
              mode: LaunchMode.externalApplication); // Melhor para SaaS Web
          return true; // Retorna true indicando que o fluxo iniciou
        } else {
          debugPrint('Não foi possível abrir a URL: $checkoutUrl');
          return false;
        }
      } else {
        debugPrint('Erro MP: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Exceção ao processar Mercado Pago: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // STRIPE (Mantido com flutter_stripe)
  // ---------------------------------------------------------------------------

  Future<bool> processStripePayment(double amount, String currency) async {
    try {
      // Passo 1: Obter Client Secret do seu Backend (Simulado)
      // O 'http' aqui já será a versão moderna compatível com todo o projeto.
      // final response = await http.post(...)

      // Simulação de dados para exemplo
      const clientSecret = 'sk_test_...';

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'OminiFlow',
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.dark,
          currencyCode: currency,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      debugPrint('Stripe Payment successful');
      return true;
    } on StripeException catch (e) {
      debugPrint('Erro Stripe: ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      debugPrint('Erro genérico Stripe: $e');
      return false;
    }
  }
}
