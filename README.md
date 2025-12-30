# 🛡️ SSO Identity Provider (Rails)

This project is a **Ruby on Rails–based SAML Identity Provider (IdP)**, similar in concept to **Okta / Azure AD**.
It allows multiple **Service Provider (SP) applications** to authenticate users using **SAML 2.0 Single Sign-On (SSO)**.

The system supports:

* Multiple organizations per user
* Organization-based access control
* Admin panel for managing Service Providers
* Audit logging for SSO activities

---

## 🚀 Features

* ✅ SAML 2.0 Identity Provider
* ✅ Multi-organization support
* ✅ Admin & Super Admin roles
* ✅ Service Provider registration
* ✅ Organization-based data isolation
* ✅ Audit logs for authentication events
* ✅ Admin dashboard with statistics
* ✅ Devise-based authentication
* ✅ Rails 6 compatible

---

## 🏗️ Architecture Overview

```
+---------------------+        SAML Auth Request        +----------------------+
| Service Provider    | ----------------------------> | SSO Identity Provider |
| (Rails / Any App)   |                               | (This App)            |
|                     | <---------------------------- |                      |
+---------------------+        SAML Response            +----------------------+
```

---

## 🔐 Authentication Flow (SAML)

### 1️⃣ Service Provider Initiates Login

* User clicks **Login**
* SP redirects to IdP `/saml/auth`

### 2️⃣ Identity Provider Authenticates User

* User logs in via email/password
* If user belongs to multiple organizations → organization selection screen

### 3️⃣ Organization Context Applied

* Selected organization becomes active
* Only data related to that organization is accessible

### 4️⃣ SAML Response Sent Back

* IdP signs and sends SAML Response to SP’s ACS URL
* SP validates response and logs the user in

---

## 🧑‍💼 User & Organization Flow

* A **user can belong to multiple organizations**
* After login:

  * If **1 organization** → auto-selected
  * If **multiple organizations** → user selects one
* All permissions, service providers, and audit logs are scoped to the selected organization

---

## 🧩 Roles & Access

| Role        | Access                      |
| ----------- | --------------------------- |
| Super Admin | All organizations           |
| Admin       | Organization-specific admin |
| User        | SSO login only              |

---

## 📦 Tech Stack

* Ruby on Rails 6
* PostgreSQL
* Devise (Authentication)
* ruby-saml (SAML)
* Bootstrap (Admin UI)
* Kaminari (Pagination)
* Docker & Docker Compose (for development setup)
* Redis (Background jobs, caching)
* Elasticsearch (Search & indexing)

---

## ⚙️ Setup Instructions

You can run the app either **directly on Rails** or **using Docker**.

---

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/your-org/sso-identity-provider.git
cd sso-identity-provider
```

---

### 2️⃣ Using Docker (Recommended)

#### a) Build Docker Images

```bash
docker compose build
```

#### b) Start All Services

```bash
docker compose up
```

This will start:

* Rails app → [http://localhost:3000](http://localhost:3000)
* PostgreSQL → port 5432
* Redis → port 6379
* Elasticsearch → port 9200

> The app waits for DB and Elasticsearch to be ready before starting.

#### c) Run Rails Commands Inside Container

```bash
# Migrate the database
docker compose run --rm app rails db:create db:migrate db:seed

# Open Rails console
docker compose run --rm app rails console
```

#### d) Stop Services

```bash
docker compose down
```

> Add `-v` to remove persistent volumes:
> `docker compose down -v`

---

### 3️⃣ Without Docker (Local Setup)

#### a) Install Dependencies

```bash
bundle install
```

#### b) Database Setup

```bash
rails db:create
rails db:migrate
rails db:seed
```

#### c) Start the Rails Server

```bash
rails s
```

App will be available at:

```
http://localhost:3000
```

---

## 🔑 SAML Endpoints

| Endpoint         | Description                  |
| ---------------- | ---------------------------- |
| `/saml/metadata` | Identity Provider Metadata   |
| `/saml/auth`     | SAML Authentication Endpoint |
| `/users/sign_in` | User Login                   |
| `/admin`         | Admin Dashboard              |

---

## 🏢 Registering a Service Provider

From **Admin Panel → Service Providers**:

Required details:

* **Name**
* **Entity ID**
* **ACS URL**
* **Certificate (optional)**

These details must match the Service Provider configuration.

---

## 🧪 Testing with a Rails Service Provider App

You can create a separate Rails app as a **Service Provider** and configure it using:

* IdP Metadata URL
* IdP SSO URL
* IdP Certificate

This setup works exactly like:

> **Rails App ↔ Okta**

---

## 📜 Audit Logs

The system logs:

* User logins
* SAML authentications
* Service Provider changes
* Admin actions

Each log is scoped to:

* Organization
* User
* IP address

---

## 🔒 Security Notes

* Signed SAML assertions
* Organization-based data isolation
* CSRF protection enabled
* Role-based authorization

---

## 🛠️ Future Enhancements

* ⏳ OIDC / OAuth2 support
* ⏳ MFA integration
* ⏳ Attribute mapping UI
* ⏳ IdP-initiated login
* ⏳ SCIM provisioning

---

## 📄 License

MIT License
