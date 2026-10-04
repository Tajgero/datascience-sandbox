import os
import pandas as pd
from sqlalchemy import create_engine

# Folder z plikami CSV
folder = "dataset"

# Tworzy bazę SQLite
engine = create_engine("sqlite:///olist_database_sqllite.db")

# Iteracja po wszystkich plikach CSV
for file in os.listdir(folder):
    if file.endswith(".csv"):
        path = os.path.join(folder, file)

        # Wczytanie CSV
        df = pd.read_csv(path)

        # Nazwa tabeli = nazwa pliku bez rozszerzenia
        table_name = os.path.splitext(file)[0]

        # Zapis do bazy
        df.to_sql(table_name, engine, if_exists="replace", index=False)

        print(f"Utworzono tabelę: {table_name}")

print("Gotowe!")




# from pathlib import Path
# import sqlite3

# import pandas as pd


# DATASET_DIR = Path("dataset")
# DATABASE_PATH = Path("olist.db")


# TABLE_FILES = {
#     "customers": "olist_customers_dataset.csv",
#     "orders": "olist_orders_dataset.csv",
#     "products": "olist_products_dataset.csv",
#     "sellers": "olist_sellers_dataset.csv",
#     "order_items": "olist_order_items_dataset.csv",
#     "order_payments": "olist_order_payments_dataset.csv",
#     "order_reviews": "olist_order_reviews_dataset.csv",
#     "geolocation": "olist_geolocation_dataset.csv",
#     "category_translation": "product_category_name_translation.csv",
# }


# CREATE_TABLES_SQL = """
# CREATE TABLE customers (
#     customer_id TEXT PRIMARY KEY,
#     customer_unique_id TEXT,
#     customer_zip_code_prefix INTEGER,
#     customer_city TEXT,
#     customer_state TEXT
# );

# CREATE TABLE orders (
#     order_id TEXT PRIMARY KEY,
#     customer_id TEXT,
#     order_status TEXT,
#     order_purchase_timestamp TEXT,
#     order_approved_at TEXT,
#     order_delivered_carrier_date TEXT,
#     order_delivered_customer_date TEXT,
#     order_estimated_delivery_date TEXT,

#     FOREIGN KEY (customer_id)
#         REFERENCES customers(customer_id)
# );

# CREATE TABLE products (
#     product_id TEXT PRIMARY KEY,
#     product_category_name TEXT,
#     product_name_lenght INTEGER,
#     product_description_lenght INTEGER,
#     product_photos_qty INTEGER,
#     product_weight_g REAL,
#     product_length_cm REAL,
#     product_height_cm REAL,
#     product_width_cm REAL
# );

# CREATE TABLE sellers (
#     seller_id TEXT PRIMARY KEY,
#     seller_zip_code_prefix INTEGER,
#     seller_city TEXT,
#     seller_state TEXT
# );

# CREATE TABLE order_items (
#     order_id TEXT,
#     order_item_id INTEGER,
#     product_id TEXT,
#     seller_id TEXT,
#     shipping_limit_date TEXT,
#     price REAL,
#     freight_value REAL,

#     PRIMARY KEY (order_id, order_item_id),

#     FOREIGN KEY (order_id)
#         REFERENCES orders(order_id),

#     FOREIGN KEY (product_id)
#         REFERENCES products(product_id),

#     FOREIGN KEY (seller_id)
#         REFERENCES sellers(seller_id)
# );

# CREATE TABLE order_payments (
#     order_id TEXT,
#     payment_sequential INTEGER,
#     payment_type TEXT,
#     payment_installments INTEGER,
#     payment_value REAL,

#     PRIMARY KEY (order_id, payment_sequential),

#     FOREIGN KEY (order_id)
#         REFERENCES orders(order_id)
# );

# CREATE TABLE order_reviews (
#     review_id TEXT,
#     order_id TEXT,
#     review_score INTEGER,
#     review_comment_title TEXT,
#     review_comment_message TEXT,
#     review_creation_date TEXT,
#     review_answer_timestamp TEXT,

#     FOREIGN KEY (order_id)
#         REFERENCES orders(order_id)
# );

# CREATE TABLE geolocation (
#     geolocation_zip_code_prefix INTEGER,
#     geolocation_lat REAL,
#     geolocation_lng REAL,
#     geolocation_city TEXT,
#     geolocation_state TEXT
# );

# CREATE TABLE category_translation (
#     product_category_name TEXT,
#     product_category_name_english TEXT
# );
# """


# IMPORT_ORDER = [
#     "customers",
#     "products",
#     "sellers",
#     "orders",
#     "order_items",
#     "order_payments",
#     "order_reviews",
#     "geolocation",
#     "category_translation",
# ]


# def validate_csv_columns() -> None:
#     expected_columns = {
#         "customers": [
#             "customer_id",
#             "customer_unique_id",
#             "customer_zip_code_prefix",
#             "customer_city",
#             "customer_state",
#         ],
#         "orders": [
#             "order_id",
#             "customer_id",
#             "order_status",
#             "order_purchase_timestamp",
#             "order_approved_at",
#             "order_delivered_carrier_date",
#             "order_delivered_customer_date",
#             "order_estimated_delivery_date",
#         ],
#         "products": [
#             "product_id",
#             "product_category_name",
#             "product_name_lenght",
#             "product_description_lenght",
#             "product_photos_qty",
#             "product_weight_g",
#             "product_length_cm",
#             "product_height_cm",
#             "product_width_cm",
#         ],
#         "sellers": [
#             "seller_id",
#             "seller_zip_code_prefix",
#             "seller_city",
#             "seller_state",
#         ],
#         "order_items": [
#             "order_id",
#             "order_item_id",
#             "product_id",
#             "seller_id",
#             "shipping_limit_date",
#             "price",
#             "freight_value",
#         ],
#         "order_payments": [
#             "order_id",
#             "payment_sequential",
#             "payment_type",
#             "payment_installments",
#             "payment_value",
#         ],
#         "order_reviews": [
#             "review_id",
#             "order_id",
#             "review_score",
#             "review_comment_title",
#             "review_comment_message",
#             "review_creation_date",
#             "review_answer_timestamp",
#         ],
#         "geolocation": [
#             "geolocation_zip_code_prefix",
#             "geolocation_lat",
#             "geolocation_lng",
#             "geolocation_city",
#             "geolocation_state",
#         ],
#         "category_translation": [
#             "product_category_name",
#             "product_category_name_english",
#         ],
#     }

#     for table_name, filename in TABLE_FILES.items():
#         csv_path = DATASET_DIR / filename

#         if not csv_path.exists():
#             raise FileNotFoundError(
#                 f"Nie znaleziono pliku: {csv_path}"
#             )

#         actual_columns = pd.read_csv(
#             csv_path,
#             nrows=0,
#         ).columns.tolist()

#         required_columns = expected_columns[table_name]

#         if actual_columns != required_columns:
#             raise ValueError(
#                 f"\nNieprawidłowy schemat pliku: {csv_path}\n"
#                 f"Oczekiwane kolumny:\n{required_columns}\n"
#                 f"Rzeczywiste kolumny:\n{actual_columns}"
#             )


# def build_database() -> None:
#     validate_csv_columns()

#     if DATABASE_PATH.exists():
#         DATABASE_PATH.unlink()

#     connection = sqlite3.connect(DATABASE_PATH)

#     try:
#         connection.execute("PRAGMA foreign_keys = ON")
#         connection.executescript(CREATE_TABLES_SQL)

#         for table_name in IMPORT_ORDER:
#             csv_path = DATASET_DIR / TABLE_FILES[table_name]

#             dataframe = pd.read_csv(
#                 csv_path,
#                 low_memory=False,
#             )

#             dataframe.to_sql(
#                 name=table_name,
#                 con=connection,
#                 if_exists="append",
#                 index=False,
#                 chunksize=10_000,
#             )

#             print(
#                 f"Wczytano: {table_name} "
#                 f"({len(dataframe):,} wierszy)"
#             )

#         foreign_key_errors = connection.execute(
#             "PRAGMA foreign_key_check"
#         ).fetchall()

#         if foreign_key_errors:
#             raise RuntimeError(
#                 "Wykryto błędne relacje kluczy obcych:\n"
#                 f"{foreign_key_errors[:10]}"
#             )

#         connection.commit()

#         print()
#         print(f"Utworzono bazę: {DATABASE_PATH.resolve()}")

#     except Exception:
#         connection.rollback()
#         connection.close()

#         if DATABASE_PATH.exists():
#             DATABASE_PATH.unlink()

#         raise

#     else:
#         connection.close()


# if __name__ == "__main__":
#     build_database()




# import os
# from pathlib import Path

# import pandas as pd
# import psycopg
# from dotenv import load_dotenv
# from psycopg import sql
# from sqlalchemy import create_engine, text
# from sqlalchemy.engine import Connection, Engine, URL


# # Wczytuje zmienne z pliku .env znajdującego się obok skryptu.
# load_dotenv()


# DATASET_DIR = Path("dataset")


# POSTGRES_USER = os.getenv("POSTGRES_USER", "kkawa2")
# POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD") or None
# POSTGRES_HOST = os.getenv("POSTGRES_HOST", "/tmp")
# POSTGRES_PORT = int(os.getenv("POSTGRES_PORT", "5432"))
# POSTGRES_DB = os.getenv("POSTGRES_DB", "olist")


# TABLE_FILES = {
#     "customers": "olist_customers_dataset.csv",
#     "orders": "olist_orders_dataset.csv",
#     "products": "olist_products_dataset.csv",
#     "sellers": "olist_sellers_dataset.csv",
#     "order_items": "olist_order_items_dataset.csv",
#     "order_payments": "olist_order_payments_dataset.csv",
#     "order_reviews": "olist_order_reviews_dataset.csv",
#     "geolocation": "olist_geolocation_dataset.csv",
#     "category_translation": "product_category_name_translation.csv",
# }


# DROP_TABLES_SQL = """
# DROP TABLE IF EXISTS order_reviews CASCADE;
# DROP TABLE IF EXISTS order_payments CASCADE;
# DROP TABLE IF EXISTS order_items CASCADE;
# DROP TABLE IF EXISTS orders CASCADE;
# DROP TABLE IF EXISTS products CASCADE;
# DROP TABLE IF EXISTS sellers CASCADE;
# DROP TABLE IF EXISTS customers CASCADE;
# DROP TABLE IF EXISTS geolocation CASCADE;
# DROP TABLE IF EXISTS category_translation CASCADE;
# """


# CREATE_TABLES_SQL = """
# CREATE TABLE customers (
#     customer_id TEXT PRIMARY KEY,
#     customer_unique_id TEXT,
#     customer_zip_code_prefix INTEGER,
#     customer_city TEXT,
#     customer_state TEXT
# );

# CREATE TABLE orders (
#     order_id TEXT PRIMARY KEY,
#     customer_id TEXT,
#     order_status TEXT,
#     order_purchase_timestamp TIMESTAMP,
#     order_approved_at TIMESTAMP,
#     order_delivered_carrier_date TIMESTAMP,
#     order_delivered_customer_date TIMESTAMP,
#     order_estimated_delivery_date TIMESTAMP,

#     CONSTRAINT fk_orders_customer
#         FOREIGN KEY (customer_id)
#         REFERENCES customers(customer_id)
# );

# CREATE TABLE products (
#     product_id TEXT PRIMARY KEY,
#     product_category_name TEXT,
#     product_name_lenght INTEGER,
#     product_description_lenght INTEGER,
#     product_photos_qty INTEGER,
#     product_weight_g DOUBLE PRECISION,
#     product_length_cm DOUBLE PRECISION,
#     product_height_cm DOUBLE PRECISION,
#     product_width_cm DOUBLE PRECISION
# );

# CREATE TABLE sellers (
#     seller_id TEXT PRIMARY KEY,
#     seller_zip_code_prefix INTEGER,
#     seller_city TEXT,
#     seller_state TEXT
# );

# CREATE TABLE order_items (
#     order_id TEXT,
#     order_item_id INTEGER,
#     product_id TEXT,
#     seller_id TEXT,
#     shipping_limit_date TIMESTAMP,
#     price NUMERIC(12, 2),
#     freight_value NUMERIC(12, 2),

#     PRIMARY KEY (order_id, order_item_id),

#     CONSTRAINT fk_order_items_order
#         FOREIGN KEY (order_id)
#         REFERENCES orders(order_id),

#     CONSTRAINT fk_order_items_product
#         FOREIGN KEY (product_id)
#         REFERENCES products(product_id),

#     CONSTRAINT fk_order_items_seller
#         FOREIGN KEY (seller_id)
#         REFERENCES sellers(seller_id)
# );

# CREATE TABLE order_payments (
#     order_id TEXT,
#     payment_sequential INTEGER,
#     payment_type TEXT,
#     payment_installments INTEGER,
#     payment_value NUMERIC(12, 2),

#     PRIMARY KEY (order_id, payment_sequential),

#     CONSTRAINT fk_order_payments_order
#         FOREIGN KEY (order_id)
#         REFERENCES orders(order_id)
# );

# CREATE TABLE order_reviews (
#     review_id TEXT,
#     order_id TEXT,
#     review_score INTEGER,
#     review_comment_title TEXT,
#     review_comment_message TEXT,
#     review_creation_date TIMESTAMP,
#     review_answer_timestamp TIMESTAMP,

#     CONSTRAINT fk_order_reviews_order
#         FOREIGN KEY (order_id)
#         REFERENCES orders(order_id)
# );

# CREATE TABLE geolocation (
#     geolocation_zip_code_prefix INTEGER,
#     geolocation_lat DOUBLE PRECISION,
#     geolocation_lng DOUBLE PRECISION,
#     geolocation_city TEXT,
#     geolocation_state TEXT
# );

# CREATE TABLE category_translation (
#     product_category_name TEXT,
#     product_category_name_english TEXT
# );
# """


# IMPORT_ORDER = [
#     "customers",
#     "products",
#     "sellers",
#     "orders",
#     "order_items",
#     "order_payments",
#     "order_reviews",
#     "geolocation",
#     "category_translation",
# ]


# DATETIME_COLUMNS = {
#     "orders": [
#         "order_purchase_timestamp",
#         "order_approved_at",
#         "order_delivered_carrier_date",
#         "order_delivered_customer_date",
#         "order_estimated_delivery_date",
#     ],
#     "order_items": [
#         "shipping_limit_date",
#     ],
#     "order_reviews": [
#         "review_creation_date",
#         "review_answer_timestamp",
#     ],
# }


# EXPECTED_COLUMNS = {
#     "customers": [
#         "customer_id",
#         "customer_unique_id",
#         "customer_zip_code_prefix",
#         "customer_city",
#         "customer_state",
#     ],
#     "orders": [
#         "order_id",
#         "customer_id",
#         "order_status",
#         "order_purchase_timestamp",
#         "order_approved_at",
#         "order_delivered_carrier_date",
#         "order_delivered_customer_date",
#         "order_estimated_delivery_date",
#     ],
#     "products": [
#         "product_id",
#         "product_category_name",
#         "product_name_lenght",
#         "product_description_lenght",
#         "product_photos_qty",
#         "product_weight_g",
#         "product_length_cm",
#         "product_height_cm",
#         "product_width_cm",
#     ],
#     "sellers": [
#         "seller_id",
#         "seller_zip_code_prefix",
#         "seller_city",
#         "seller_state",
#     ],
#     "order_items": [
#         "order_id",
#         "order_item_id",
#         "product_id",
#         "seller_id",
#         "shipping_limit_date",
#         "price",
#         "freight_value",
#     ],
#     "order_payments": [
#         "order_id",
#         "payment_sequential",
#         "payment_type",
#         "payment_installments",
#         "payment_value",
#     ],
#     "order_reviews": [
#         "review_id",
#         "order_id",
#         "review_score",
#         "review_comment_title",
#         "review_comment_message",
#         "review_creation_date",
#         "review_answer_timestamp",
#     ],
#     "geolocation": [
#         "geolocation_zip_code_prefix",
#         "geolocation_lat",
#         "geolocation_lng",
#         "geolocation_city",
#         "geolocation_state",
#     ],
#     "category_translation": [
#         "product_category_name",
#         "product_category_name_english",
#     ],
# }


# def get_connection_parameters(
#     database_name: str,
# ) -> dict[str, object]:
#     """
#     Parametry połączenia używane bezpośrednio przez psycopg.
#     """

#     parameters: dict[str, object] = {
#         "dbname": database_name,
#         "user": POSTGRES_USER,
#         "host": POSTGRES_HOST,
#         "port": POSTGRES_PORT,
#     }

#     if POSTGRES_PASSWORD is not None:
#         parameters["password"] = POSTGRES_PASSWORD

#     return parameters


# def create_database_if_not_exists() -> None:
#     """
#     Łączy się z domyślną bazą postgres i tworzy bazę docelową,
#     jeśli jeszcze nie istnieje.

#     CREATE DATABASE musi zostać wykonane poza transakcją,
#     dlatego używamy autocommit=True.
#     """

#     try:
#         with psycopg.connect(
#             **get_connection_parameters("postgres"),
#             autocommit=True,
#         ) as connection:
#             database_exists = connection.execute(
#                 """
#                 SELECT EXISTS (
#                     SELECT 1
#                     FROM pg_database
#                     WHERE datname = %s
#                 )
#                 """,
#                 (POSTGRES_DB,),
#             ).fetchone()

#             exists = bool(database_exists and database_exists[0])

#             if exists:
#                 print(f"Baza PostgreSQL {POSTGRES_DB!r} już istnieje.")
#                 return

#             connection.execute(
#                 sql.SQL("CREATE DATABASE {}").format(
#                     sql.Identifier(POSTGRES_DB)
#                 )
#             )

#             print(f"Utworzono bazę PostgreSQL {POSTGRES_DB!r}.")

#     except psycopg.OperationalError as error:
#         raise RuntimeError(
#             "\nNie udało się połączyć z PostgreSQL.\n"
#             f"Użytkownik: {POSTGRES_USER}\n"
#             f"Host/socket: {POSTGRES_HOST}\n"
#             f"Port: {POSTGRES_PORT}\n\n"
#             "Sprawdź, czy PostgreSQL jest uruchomiony oraz czy dane "
#             "w pliku .env są poprawne."
#         ) from error

#     except psycopg.errors.InsufficientPrivilege as error:
#         raise RuntimeError(
#             f"Użytkownik {POSTGRES_USER!r} nie ma uprawnienia "
#             "do tworzenia baz PostgreSQL."
#         ) from error


# def create_database_url() -> URL:
#     """
#     Buduje adres dla SQLAlchemy bez ręcznego składania hasła i hosta.
#     """

#     return URL.create(
#         drivername="postgresql+psycopg",
#         username=POSTGRES_USER,
#         password=POSTGRES_PASSWORD,
#         host=POSTGRES_HOST,
#         port=POSTGRES_PORT,
#         database=POSTGRES_DB,
#     )


# def execute_sql_script(
#     connection: Connection,
#     script: str,
# ) -> None:
#     """
#     Wykonuje kolejne instrukcje SQL oddzielnie.

#     Jest to pewniejsze niż wysyłanie wielu instrukcji SQL
#     jako jednego zapytania przez sterownik psycopg.
#     """

#     statements = [
#         statement.strip()
#         for statement in script.split(";")
#         if statement.strip()
#     ]

#     for statement in statements:
#         connection.exec_driver_sql(statement)


# def validate_csv_columns() -> None:
#     for table_name, filename in TABLE_FILES.items():
#         csv_path = DATASET_DIR / filename

#         if not csv_path.exists():
#             raise FileNotFoundError(
#                 f"Nie znaleziono pliku: {csv_path.resolve()}"
#             )

#         actual_columns = pd.read_csv(
#             csv_path,
#             nrows=0,
#         ).columns.tolist()

#         required_columns = EXPECTED_COLUMNS[table_name]

#         if actual_columns != required_columns:
#             raise ValueError(
#                 f"\nNieprawidłowy schemat pliku: {csv_path}\n"
#                 f"Oczekiwane kolumny:\n{required_columns}\n"
#                 f"Rzeczywiste kolumny:\n{actual_columns}"
#             )


# def prepare_dataframe(
#     table_name: str,
#     dataframe: pd.DataFrame,
# ) -> pd.DataFrame:
#     for column in DATETIME_COLUMNS.get(table_name, []):
#         dataframe[column] = pd.to_datetime(
#             dataframe[column],
#             errors="coerce",
#         )

#     # Zamiana NaN i NaT na None, które PostgreSQL zapisuje jako NULL.
#     return dataframe.astype(object).where(
#         pd.notna(dataframe),
#         None,
#     )


# def verify_foreign_keys(engine: Engine) -> None:
#     checks = {
#         "orders.customer_id": """
#             SELECT COUNT(*)
#             FROM orders o
#             LEFT JOIN customers c
#                 ON c.customer_id = o.customer_id
#             WHERE c.customer_id IS NULL
#         """,
#         "order_items.order_id": """
#             SELECT COUNT(*)
#             FROM order_items oi
#             LEFT JOIN orders o
#                 ON o.order_id = oi.order_id
#             WHERE o.order_id IS NULL
#         """,
#         "order_items.product_id": """
#             SELECT COUNT(*)
#             FROM order_items oi
#             LEFT JOIN products p
#                 ON p.product_id = oi.product_id
#             WHERE p.product_id IS NULL
#         """,
#         "order_items.seller_id": """
#             SELECT COUNT(*)
#             FROM order_items oi
#             LEFT JOIN sellers s
#                 ON s.seller_id = oi.seller_id
#             WHERE s.seller_id IS NULL
#         """,
#         "order_payments.order_id": """
#             SELECT COUNT(*)
#             FROM order_payments op
#             LEFT JOIN orders o
#                 ON o.order_id = op.order_id
#             WHERE o.order_id IS NULL
#         """,
#         "order_reviews.order_id": """
#             SELECT COUNT(*)
#             FROM order_reviews r
#             LEFT JOIN orders o
#                 ON o.order_id = r.order_id
#             WHERE o.order_id IS NULL
#         """,
#     }

#     errors: dict[str, int] = {}

#     with engine.connect() as connection:
#         for relation_name, query in checks.items():
#             invalid_rows = connection.execute(
#                 text(query)
#             ).scalar_one()

#             if invalid_rows:
#                 errors[relation_name] = invalid_rows

#     if errors:
#         details = "\n".join(
#             f"- {relation}: {count} błędnych rekordów"
#             for relation, count in errors.items()
#         )

#         raise RuntimeError(
#             "Wykryto błędne relacje kluczy obcych:\n"
#             f"{details}"
#         )


# def import_csv_files(engine: Engine) -> None:
#     """
#     Usuwa istniejące tabele, tworzy je ponownie i importuje CSV.

#     Cała operacja jest wykonywana w jednej transakcji.
#     W przypadku błędu SQLAlchemy wykona rollback.
#     """

#     with engine.begin() as connection:
#         execute_sql_script(
#             connection,
#             DROP_TABLES_SQL,
#         )

#         execute_sql_script(
#             connection,
#             CREATE_TABLES_SQL,
#         )

#         for table_name in IMPORT_ORDER:
#             csv_path = DATASET_DIR / TABLE_FILES[table_name]

#             dataframe = pd.read_csv(
#                 csv_path,
#                 low_memory=False,
#             )

#             dataframe = prepare_dataframe(
#                 table_name,
#                 dataframe,
#             )

#             dataframe.to_sql(
#                 name=table_name,
#                 con=connection,
#                 if_exists="append",
#                 index=False,
#                 chunksize=1_000,
#             )

#             print(
#                 f"Wczytano: {table_name} "
#                 f"({len(dataframe):,} wierszy)"
#             )


# def build_database() -> None:
#     validate_csv_columns()

#     create_database_if_not_exists()

#     database_url = create_database_url()

#     engine = create_engine(
#         database_url,
#         pool_pre_ping=True,
#     )

#     try:
#         # Sprawdzenie połączenia przed rozpoczęciem importu.
#         with engine.connect() as connection:
#             connection.execute(text("SELECT 1"))

#         import_csv_files(engine)
#         verify_foreign_keys(engine)

#         print()
#         print("Import zakończony poprawnie.")
#         print(f"Baza: {POSTGRES_DB}")
#         print(f"Użytkownik: {POSTGRES_USER}")
#         print(f"Host/socket: {POSTGRES_HOST}")
#         print(f"Port: {POSTGRES_PORT}")

#     except Exception:
#         print()
#         print("Import nie powiódł się.")
#         raise

#     finally:
#         engine.dispose()


# if __name__ == "__main__":
#     build_database()