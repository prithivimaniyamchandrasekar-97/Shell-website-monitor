 🖥️ Shell Website Monitoring Project

A lightweight, real-time uptime monitoring system built using **Bash**, designed to check multiple websites, log availability status, and trigger alerts when websites are down.  
The project is deployed on AWS EC2 (Ubuntu) and runs automatically using **cron scheduling**.

<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/d4bee196-611f-4bfd-bfe2-3866b78e014f" />



🚀 Key Features

| Feature | Status |
|--------|--------|
| Monitor multiple websites | ✔ |
| Log HTTP status & response time | ✔ |
| Detect unreachable websites | ✔ |
| Alerting logged for DOWN websites | ✔ |
| Auto-runs every 5 minutes using cron | ✔ |
| Deployed on AWS EC2 | ✔ |


🧠 How It Works

1. List all URLs inside `websites.txt`
2. The script `website_monitor.sh` reads each URL and uses `curl` to:
   - Check HTTP response code
   - Measure response time
3. Results are logged in `website_monitor.log`
4. For failed requests (curl error or HTTP ≥ 400), an **ALERT** is logged
5. Cron automatically executes the script every 5 minutes

 📂 Project Structure
Shell-website-monitor/
│
├── website_monitor.sh # Main monitoring script
├── websites.txt # List of websites to monitor
├── website_monitor.log # Log file for manual runs
├── cron.log # Log file for scheduled runs
└── README.md # Documentation
