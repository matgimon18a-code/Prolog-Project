# 🧠 Proyecto Prolog -- Bases de Datos y Consultas Lógicas

Autores: **Matias Gil Montoya** y **Juliana Sepulveda**\
Fecha: 09/10/2025

------------------------------------------------------------------------

## 📘 1. Base de Datos de Plataformas

### 🧩 Descripción General

Este programa en **Prolog** gestiona una base de datos de diferentes
**plataformas tecnológicas** (computadores, laptops, tablets, etc.) con
información detallada sobre sus características de hardware: marca,
procesador, cantidad de memoria RAM, capacidad de disco, tipo de
dispositivo, GPU, VRAM, entre otros.

Además de la base de datos, el programa incluye un conjunto de
**consultas principales** y **consultas adicionales** que permiten
realizar búsquedas específicas sobre las plataformas registradas.

El **objetivo** del código es demostrar el uso de consultas lógicas en
Prolog aplicadas a un conjunto de hechos estructurados, mostrando cómo
se puede filtrar, comparar y presentar información de forma declarativa.

### ⚙️ Estructura del Código

1.  **Base de Datos de Plataformas:** Contiene los hechos
    `plataforma/10` con los datos de cada equipo.\
2.  **Consultas Principales:** Predicados `query1` a `query5` que
    realizan búsquedas estándar.\
3.  **Consultas Adicionales:** Predicados `extra1` a `extra4` con
    filtros más específicos.\
4.  **Programa Principal (`main`):** Ejecuta automáticamente varias
    consultas consecutivas mostrando resultados en consola.

### ▶️ Ejemplo de Ejecución del Programa Principal

**Entrada:**

``` prolog
?- main.
```

**Salida esperada (fragmento):**

    --- CONSULTAS PRINCIPALES ---

    1. Plataformas con CPU AMD adquiridas después de 2021:
    ASUS - A006
    HP - A011
    Acer - A013
    ...

    --- CONSULTAS ADICIONALES ---

    1. Computadores con más de 8 núcleos y más de 8GB de RAM:
    Dell - A005
    MSI - A009
    MSI - A018
    ...

### 💡 Conclusión

El código demuestra cómo Prolog puede usarse eficazmente para: -
Representar conocimiento estructurado.\
- Formular consultas complejas mediante relaciones lógicas.\
- Mostrar resultados dinámicos sin requerir interacción del usuario.

Este tipo de programa es ideal para aplicaciones académicas o sistemas
de soporte donde se requiera **filtrado lógico de datos estructurados**.

------------------------------------------------------------------------

## 🧭 2. Sistema de Planificación de Rutas

### 🧩 Descripción General

Este segundo programa en **Prolog** implementa un sistema para la
**planificación de viajes** entre ciudades colombianas. La base de datos
`ruta/7` incluye información de transporte como origen, destino, medio
de transporte, horarios, costo y disponibilidad.

El sistema permite consultar rutas directas, rutas con escalas, rutas
más rápidas o más baratas, y generar sugerencias automáticas. Además,
incluye un **menú principal** con todas las consultas disponibles.

### ⚙️ Estructura del Código

1.  **Base de Datos de Rutas:** Define hechos `ruta/7` con información
    completa.\
2.  **Consultas Básicas:** Predicados para listar y filtrar rutas
    directas.\
3.  **Planificación con Escalas:** Permite calcular rutas con una o
    varias paradas.\
4.  **Optimización:** Busca la ruta más rápida o la más económica.\
5.  **Consultas Adicionales:** Filtra por horarios, medios o
    disponibilidad.\
6.  **Menú Principal (`menu/0`):** Interfaz textual con todas las
    opciones del sistema.

### ▶️ Ejemplo de Ejecución

**Entrada:**

``` prolog
?- sugerir_mejor_alternativa(bogota, cartagena).
```

**Salida esperada:**

    HAY RUTA DIRECTA DISPONIBLE:
    Rutas disponibles
    avion - 8h - $120

Otro ejemplo:

**Entrada:**

``` prolog
?- ruta_mas_barata(bogota, medellin).
```

**Salida esperada:**

    Ruta mas barata: [bogota, medellin]
    Costo: $35 - Tiempo: 9h

### 💡 Conclusión

El sistema de rutas demuestra el potencial de Prolog para manejar
**búsquedas recursivas** y **evaluaciones condicionales**.\
Permite encontrar rutas óptimas bajo distintos criterios y modelar
comportamientos reales de planificación de viajes.

------------------------------------------------------------------------

## 📄 Información General del Proyecto

**Lenguaje:** Prolog\  

**Autores:**\
**Matias Gil Montoya**\
**Juliana Sepulveda**
