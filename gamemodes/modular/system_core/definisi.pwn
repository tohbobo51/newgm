// Info server
#define NamaServer  "MYSQL R41-4"
#define Versi       "1.5"
#define Bahasa      "Indonesia"
#define GM_NAME     "BASIC MYSQL"
#define WEB         "google.com"

// Mode MySQL
#if defined MYSQL_LOCALHOST
	#define MYSQL_HOST "127.0.0.1"
	#define MYSQL_USER "root"
	#define MYSQL_PASS ""
	#define MYSQL_DBSE "hendiganteng"
#else
	#define MYSQL_HOST "127.0.0.1"
	#define MYSQL_USER "root"
	#define MYSQL_PASS ""
	#define MYSQL_DBSE "hendiganteng"
#endif

// Makro
#define Fungsi:%0(%1) forward %0(%1); public %0(%1)
#define MAX_CHARS 5

// bcrypt
#define BCRYPT_HASH_LENGTH 250
#define BCRYPT_COST 12
