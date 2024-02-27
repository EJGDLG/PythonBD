import psycopg2
import csv
from pathlib import Path

def leer_archivo_csv(ruta_archivo):
    datos_csv = []
    with open(ruta_archivo, newline='', encoding='utf-8') as archivo_csv:
        lector_csv = csv.reader(archivo_csv)
        # Saltar la primera línea si contiene encabezados de columna
        next(lector_csv)
        for fila in lector_csv:
            # Convertir el valor de teamid a entero
            fila[0] = int(fila[0])
            datos_csv.append(fila)
    return datos_csv


def conectar_base_datos(host, puerto, base_datos, usuario, clave):
    try:
        conexion = psycopg2.connect(host=host, port=puerto, dbname=base_datos, user=usuario, password=clave)
        return conexion
    except psycopg2.Error as e:
        print("Error al conectar a la base de datos:", e)
        return None

def alimentar_tabla(conexion, nombre_tabla, datos):
    cursor = conexion.cursor()
    try:
        for fila in datos:
            cursor.execute("""
                INSERT INTO {} (gameID, teamID, season, date, location, goals, xGoals, shots, shotsOnTarget, deep, ppda, fouls, corners, yellowCards, redCards, result) 
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """.format(nombre_tabla), fila)
        conexion.commit()
        print("Datos insertados correctamente en la tabla", nombre_tabla)
    except psycopg2.Error as e:
        print("Error al insertar datos en la tabla:", e)
        conexion.rollback()
    finally:
        cursor.close()

        
# Configuración de la conexión a la base de datos PostgreSQL
HOST = 'localhost'
PUERTO = '5432'
BASE_DATOS = 'RankingMundial'
USUARIO = 'postgres'
CLAVE = '123'

# Ruta al archivo CSV
RUTA_ARCHIVO_CSV = 'C:/Users/edwin/Downloads/teamstats.csv'

# Nombre de la tabla en la base de datos PostgreSQL
NOMBRE_TABLA = 'teamstats'

# Leer datos del archivo CSV
datos_csv = leer_archivo_csv(RUTA_ARCHIVO_CSV)

# Conectar a la base de datos
conexion = conectar_base_datos(HOST, PUERTO, BASE_DATOS, USUARIO, CLAVE)

if conexion is not None:
    # Alimentar la tabla en la base de datos
    alimentar_tabla(conexion, NOMBRE_TABLA, datos_csv)
    conexion.close()
else:
    print("No se pudo establecer la conexión a la base de datos.")
