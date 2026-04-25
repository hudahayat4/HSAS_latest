package appointment;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class SendNotificationService {

    private final String fromEmail = "juz.care.26@gmail.com";
    private final String appPassword = "dwxx fxxd cqit icnq";

    private Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        return Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });
    }

    private void sendStyledEmail(String to, String subject, String title, String messageBody, String date, String time) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(fromEmail, "JuzCare Pharmacy"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);

            String htmlContent = 
                "<div style=\"font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; padding: 30px; border-radius: 10px;\">" +
                "  <div style=\"max-width: 550px; margin: auto; background-color: #ffffff; border-radius: 15px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-top: 5px solid #3CACAE;\">" +
                "    <div style=\"padding: 30px; text-align: center;\">" +
                "      <h1 style=\"color: #3CACAE; margin-bottom: 10px;\">JuzCare</h1>" +
                "      <h2 style=\"color: #333; font-size: 20px;\">" + title + "</h2>" +
                "      <p style=\"color: #555; font-size: 16px; line-height: 1.5;\">Hai,</p>" +
                "      <p style=\"color: #555; font-size: 16px; line-height: 1.5;\">" + messageBody + "</p>" +
                
                "      <div style=\"margin: 25px 0; padding: 20px; background-color: #f9f9f9; border: 1px solid #eee; border-radius: 10px; text-align: left;\">" +
                "        <p style=\"margin: 5px 0; color: #333;\"><strong>📅 Tarikh:</strong> " + date + "</p>" +
                "        <p style=\"margin: 5px 0; color: #333;\"><strong>⏰ Masa:</strong> " + time + "</p>" +
                "        <p style=\"margin: 5px 0; color: #333;\"><strong>📍 Lokasi:</strong> Cawangan Utama JuzCare Pharmacy</p>" +
                "      </div>" +
                
                "      <p style=\"color: #555; font-size: 14px;\">Sila hadir 10 minit lebih awal untuk urusan pendaftaran. Terima kasih!</p>" +
                "      <p style=\"color: #888; font-size: 12px; margin-top: 25px;\">Jika anda ingin menukar jadual, sila hubungi kami di talian bantuan.</p>" +
                "    </div>" +
                "    <div style=\"background-color: #3CACAE; color: #ffffff; padding: 15px; text-align: center; font-size: 12px;\">" +
                "      &copy; 2026 JuzCare Pharmacy. Menjaga Kesihatan Anda." +
                "    </div>" +
                "  </div>" +
                "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println("Email Notification sent to " + to);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Reminder 2 days before
    public void sendTwoDaysReminder(String email, String apptDate, String apptTime) {
        sendStyledEmail(email, 
            "📅 Peringatan Temu Janji JuzCare (2 Hari Lagi)", 
            "Peringatan Temu Janji",
            "Ini adalah peringatan mesra bahawa anda mempunyai temu janji pemeriksaan kesihatan dalam masa <b>2 hari</b> lagi.",
            apptDate, apptTime);
    }

    // Reminder 1 day before
    public void sendOneDayReminder(String email, String apptDate, String apptTime) {
        sendStyledEmail(email, 
            "🔔 Temu Janji JuzCare Anda Esok", 
            "Peringatan Temu Janji",
            "Kami tidak sabar untuk berjumpa anda <b>esok</b> bagi pemeriksaan kesihatan yang telah dijadualkan.",
            apptDate, apptTime);
    }

    // Reminder 2 hours before
    public void sendTwoHoursReminder(String email, String apptDate, String apptTime) {
        sendStyledEmail(email, 
            "⚡ Peringatan Terakhir: 2 Jam Lagi", 
            "Peringatan Terakhir",
            "Temu janji anda akan bermula dalam masa <b>2 jam</b> sahaja lagi. Sila pastikan anda dalam perjalanan.",
            apptDate, apptTime);
    }
}