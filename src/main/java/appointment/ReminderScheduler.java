/*package appointment;

import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

public class ReminderScheduler {

    private final Timer timer;

    public ReminderScheduler() {
        timer = new Timer(true); // run as daemon thread
        // Schedule task setiap 1 jam (3600000 ms)
        timer.scheduleAtFixedRate(new ReminderTask(), 0, 3600000);
        System.out.println("ReminderScheduler started...");
    }

    class ReminderTask extends TimerTask {
        @Override
        public void run() {
            try {
                System.out.println("Running reminder check...");

                // Reminder 2 hari sebelum
                List<appointment> twoDaysList = AppointmentDAO.getAppointmentsForReminder(2, "DAY");
                for (appointment apt : twoDaysList) {
                    SendNotificationService service = new SendNotificationService();
                    boolean sent = service.sendTwoDaysReminder(
                            apt.getCustomerEmail(),
                            apt.getApptDate().toString(),
                            apt.getApptTime().toString()
                    );
                    if (sent) {
                        AppointmentDAO.updateNotificationStatus(apt.getAppointmentID(), "REMINDER1_SENT");
                        System.out.println("2-day reminder sent to " + apt.getCustomerEmail());
                    }
                }

                // Reminder 1 hari sebelum
                List<appointment> oneDayList = AppointmentDAO.getAppointmentsForReminder(1, "DAY");
                for (appointment apt : oneDayList) {
                    SendNotificationService service = new SendNotificationService();
                    boolean sent = service.sendOneDayReminder(
                            apt.getCustomerEmail(),
                            apt.getApptDate().toString(),
                            apt.getApptTime().toString()
                    );
                    if (sent) {
                        AppointmentDAO.updateNotificationStatus(apt.getAppointmentID(), "REMINDER2_SENT");
                        System.out.println("1-day reminder sent to " + apt.getCustomerEmail());
                    }
                }

                // Reminder 2 jam sebelum
                List<appointment> twoHoursList = AppointmentDAO.getAppointmentsForReminder(2, "HOUR");
                for (appointment apt : twoHoursList) {
                    SendNotificationService service = new SendNotificationService();
                    boolean sent = service.sendTwoHoursReminder(
                            apt.getCustomerEmail(),
                            apt.getApptDate().toString(),
                            apt.getApptTime().toString()
                    );
                    if (sent) {
                        AppointmentDAO.updateNotificationStatus(apt.getAppointmentID(), "FINAL_SENT");
                        System.out.println("2-hour reminder sent to " + apt.getCustomerEmail());
                    }
                }

            } catch (Exception e) {
                System.err.println("Error in ReminderTask: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
}*/
