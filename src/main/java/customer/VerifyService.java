package customer;

import java.sql.Timestamp;
import java.util.Random;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class VerifyService {

    /**
     * Menjana kod 6-digit, simpan ke pangkalan data, dan hantar emel kepada pelanggan.
     */
    public String generateAndSendCode(String email) {
        try {
            Timestamp now = new Timestamp(System.currentTimeMillis());
            Timestamp expiry = new Timestamp(now.getTime() + (5 * 60 * 1000)); // 5 minit tempoh sah

            // Menjana kod rawak 6-digit
            String code = String.valueOf(100000 + new Random().nextInt(900000));

            // Simpan maklumat ke pangkalan data melalui DAO
            CustomerDAO.saveVerificationCode(email.trim(), code, expiry);

            // Log untuk tujuan pembangunan (debug)
            System.out.println("generateAndSendCode → Email: " + email + " | Code: " + code + " | Expiry: " + expiry);

            // Panggil fungsi hantar emel
            sendVerificationEmail(email.trim(), code);

            return "Verification code has been sent to " + email;
        } catch (Exception e) {
            e.printStackTrace();
            return "Failed to generate verification code.";
        }
    }

    /**
     * Mengesahkan kod yang dimasukkan oleh pengguna.
     */
    public boolean verifyCode(String email, String inputCode) {
        try {
            boolean valid = CustomerDAO.isCodeValid(email.trim(), inputCode.trim());
            System.out.println("verifyCode → Email: " + email + " | Input: " + inputCode + " | Valid: " + valid);

            if (valid) {
                CustomerDAO.markAsVerified(email.trim());
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Menghantar emel pengesahan dalam format HTML yang cantik.
     */
    private void sendVerificationEmail(String to, String code) {
        final String fromEmail = "juz.care.26@gmail.com"; 
        final String appPassword = "dwxx fxxd cqit icnq"; 

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); 
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, "JuzCare Pharmacy"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            
            // Subjek emel dengan emoji untuk lebih menarik
            message.setSubject("🔑 Kod Pengesahan JuzCare Anda");

            // Kandungan Emel dalam format HTML
            String htmlContent = 
                "<div style=\"font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; padding: 30px; border-radius: 10px;\">" +
                "  <div style=\"max-width: 500px; margin: auto; background-color: #ffffff; border-radius: 15px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-top: 5px solid #3CACAE;\">" +
                "    <div style=\"padding: 30px; text-align: center;\">" +
                "      <h1 style=\"color: #3CACAE; margin-bottom: 10px;\">JuzCare</h1>" +
                "      <p style=\"color: #555; font-size: 16px;\">Hai,</p>" +
                "      <p style=\"color: #555; font-size: 16px;\">Terima kasih kerana memilih JuzCare. Sila gunakan kod di bawah untuk mengesahkan identiti anda:</p>" +
                "      <div style=\"margin: 30px 0; padding: 20px; background-color: #f9f9f9; border: 2px dashed #3CACAE; border-radius: 10px; display: inline-block; width: 80%;\">" +
                "        <span style=\"font-size: 36px; font-weight: bold; letter-spacing: 10px; color: #333;\">" + code + "</span>" +
                "      </div>" +
                "      <p style=\"color: #e74c3c; font-size: 14px; font-weight: bold;\">Kod ini akan tamat tempoh dalam masa 5 minit.</p>" +
                "      <p style=\"color: #888; font-size: 12px; margin-top: 25px;\">Jika anda tidak meminta kod ini, sila abaikan emel ini atau hubungi bantuan pelanggan kami.</p>" +
                "    </div>" +
                "    <div style=\"background-color: #3CACAE; color: #ffffff; padding: 15px; text-align: center; font-size: 12px;\">" +
                "      &copy; 2026 JuzCare Pharmacy. Menjaga Kesihatan Anda." +
                "    </div>" +
                "  </div>" +
                "</div>";

            // Gunakan setContent supaya server tahu ini adalah HTML, bukan teks biasa
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("sendVerificationEmail → Emel HTML berjaya dihantar ke " + to);
            
        } catch (Exception e) {
            System.err.println("Gagal menghantar emel: " + e.getMessage());
            e.printStackTrace();
        }
    }
}