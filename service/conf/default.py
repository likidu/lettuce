# AWS account info: app@woojuu.cc
AWS_KEY_ID = "AKIAIAARHKGCYVUCI64Q"                             # Sandbox AWS Key TODO: Replace with sandbox
AWS_SECRET_KEY = "pnrqmcV5gVKKcDhgmhoUGYfthvfZ917sOzukarq1"     # Sandbox AWS Secret TODO: Replace with sandbox

WEIBO_APP_KEY = "1948323577"                                    # Weibo App Key
WEIBO_APP_SECRET = "a9a6ba85eca70e70c227914ba2405845"           # Webio App Secret

S3_BUCKET_CLOUD_BACKUP = "woojuu-cloudbackup-sandbox"           # Sandbox S3 Bucket Name for Cloud Backup
SDB_DOMAIN_BACKUP_VERSION = "backup-version-sandbox"            # Sandbox Simple DB Domain Name for Cloud Backup Version

PRE_SIGNED_URL_EXPIRES_IN_SECONDS = 3600 * 24 * 30              # Pre-signed URL Expiration: 30 days

SANDBOX = True                                                  # Sandbox Environment: YES

# Flask settings
DEBUG = True                                                    # DEBUG in Sandbox: YES
SECRET_KEY = "VJ`yD1vUUM>AIPvU<j;x@e=D+|aj^uqKH_w,&#dB-k}%"     # Secret String for Secured Cookie
SESSION_COOKIE_SECURE = True                                    # Secure Cookie By Default: YES
SESSION_COOKIE_HTTPONLY = True                                  # Only Set Cookie For HTTP: YES (Default)

