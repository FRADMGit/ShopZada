# ShopZada
Course Project: ShopZada 2.0 – Enterprise Data Warehouse Build
# SETUP GUIDE
1. Install Docker Desktop  
2. Setup project directory / folder where you want to place `docker-compose.yml`  
3. Download [docker-compose.yml](https://github.com/FRADMGit/ShopZada/blob/main/docker-compose.yml)  
4. Open your project directory in terminal  
5. Type `docker compose up -d`  
6. In your browser, open `localhost:8080`  
Email: `admin@kestra.io`  
First Name: `kestra`  
Last Name: `kestra`  
Password: `Kestra123`  
7. Go to Flows and Import [shopzada.elt.yaml](https://github.com/FRADMGit/ShopZada/blob/main/workflows/shopzada.elt.yaml)  
8. Open the flow, go to Edit → Files, and upload these files:   
Datasets/  
├── your_data.csv  
├── your_data.html  
├── your_data.json  
├── your_data.pickle  
├── your_data.parquet  
[extract.py](https://github.com/FRADMGit/ShopZada/blob/main/scripts/extract.py)  
[schema.sql](https://github.com/FRADMGit/ShopZada/blob/main/sql/schema.sql)  
[tables_for_extract.sql](https://github.com/FRADMGit/ShopZada/blob/main/sql/tables_for_extract.sql)  
[transform.sql](https://github.com/FRADMGit/ShopZada/blob/main/sql/transform.sql)  
[view.sql](https://github.com/FRADMGit/ShopZada/blob/main/sql/view.sql)  
![Namespace](https://github.com/FRADMGit/ShopZada/blob/main/docs/Namespace.png)

---

# HOW TO OPEN DATABASE IN PGADMIN4 [OPTIONAL]
1. Make sure you have run `docker compose up -d`  
2. In your browser, open `localhost:5050`  
      Username: `admin@shopzada.com `  
      Password: `PgAdminPassword123`  
4. Right-click on Servers → Register → Server…  
   - **General:** choose any name  
   - **Connection:**  
      Host name/address: `postgres`  
      Port: `5432`
      Maintenance Database: `kestra`  
      Username: `kestra`  
      Password: `k3str4`  
5. Save

---

# HOW TO CONNECT IN TABLEAU [OPTIONAL]

1. Install and open Tableau Desktop (NOT PUBLIC)  
2. Connect to a server → More → PostgreSQL  
   - Server: `localhost`  
   - Port: `5432`  
   - Database: `kestra`  
   - Username: `kestra`  
   - Password: `k3str4`
