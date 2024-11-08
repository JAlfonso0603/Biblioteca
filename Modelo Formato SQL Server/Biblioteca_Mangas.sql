-- ----------------------------------------------------------------------------------------------------

-- Proyecto: Control de Informacion para una Biblioteca de Mangas
-- Equipo: Jose Antonio Gonzalez Cardenas | Emmanuel Saldaña Alvarez | Jesus Alfonso Cuevas Avila

-- ----------------------------------------------------------------------------------------------------
-- Dropear base de datos

DROP DATABASE Biblioteca_Mangas;

-- Crear la Base de Datos
IF DB_ID('Biblioteca_Mangas') IS NULL
CREATE DATABASE Biblioteca_Mangas;

-- Usar la Base de Datos
USE Biblioteca_Mangas;

-- Crear la tabla Usuarios
IF OBJECT_ID('Usuarios', 'U') IS NULL
CREATE TABLE Usuarios (
    idUsuario INT IDENTITY(1,1) PRIMARY KEY,
	nombrePila NVARCHAR(30) NOT NULL,
    apePat NVARCHAR(20) NOT NULL,
    apeMat NVARCHAR(20) NULL,
    usuario NVARCHAR(30) NOT NULL,
    password NVARCHAR(15) NOT NULL,
	habilitado INT NOT NULL DEFAULT 1
);

-- Crear la tabla Imprentas
IF OBJECT_ID('Imprentas','U') IS NULL
CREATE TABLE Imprentas (
	idImprenta INT IDENTITY(1,1) PRIMARY KEY,
	nombreImp NVARCHAR(30) NOT NULL,
	direccionImp NVARCHAR(50) NOT NULL,
	CP_Imp NVARCHAR(10) NOT NULL,
	paisImp NVARCHAR(20) NOT NULL,
	telefonoImp NVARCHAR(15) NOT NULL,
	emailImp NVARCHAR(30) NOT NULL
)


-- Crear tabla Distribuidores
IF OBJECT_ID('Distribuidores', 'U') IS NULL
CREATE TABLE Distribuidores (
    idDistribuidor INT IDENTITY(1,1) PRIMARY KEY,
    nombreDistribuidor NVARCHAR(100) NOT NULL,
    telefonoDist NVARCHAR(15) NULL,
    emailDist NVARCHAR(100) NULL,
	direccionDist NVARCHAR(200) NULL
)

-- Crear la tabla Guionistas
IF OBJECT_ID('Guionistas', 'U') IS NULL
CREATE TABLE Guionistas (
    idGuionista INT IDENTITY(1,1) PRIMARY KEY,
    nombreGui NVARCHAR(100) NOT NULL,
    fechaNac DATE NULL,
    nacionalidadGui NVARCHAR(50) NOT NULL,
    numeroObrasGui INT NULL,
);


-- Crear la tabla Artistas
IF OBJECT_ID('Artistas', 'U') IS NULL
CREATE TABLE Artistas (
	idArtista INT IDENTITY(1,1) PRIMARY KEY,
	nombreArt NVARCHAR(50) NOT NULL,
	fechaNac DATE NULL,
	nacionalidadArt NVARCHAR(50) NOT NULL,
	numeroObrasArt INT NULL
);


-- Crear la tabla Generos
IF OBJECT_ID('Generos', 'U') IS NULL
CREATE TABLE Generos (
	idGenero INT IDENTITY(1,1) PRIMARY KEY,
	nombreGen NVARCHAR(50) NOT NULL,
	descripcionGen NVARCHAR(200) NULL,
	habilitado BIT NOT NULL DEFAULT 1
);


--Crear la tabla Editoriales
IF OBJECT_ID('Editoriales', 'U') IS NULL
CREATE TABLE Editoriales (
	idEditorial INT IDENTITY(1,1) PRIMARY KEY,
	nombreEdit NVARCHAR(100) NOT NULL,
	paisEdit NVARCHAR(50) NOT NULL
);


-- Crear la tabla Permisos
IF OBJECT_ID('Permisos', 'U') IS NULL
CREATE TABLE Permisos (
    idPermiso INT IDENTITY (1,1) PRIMARY KEY,
	nombrePermiso NVARCHAR NOT NULL,
);

-- Crear la tabla Grupos
IF OBJECT_ID('Grupos', 'U') IS NULL
CREATE TABLE Grupos (
	idGrupo INT IDENTITY(1,1) PRIMARY KEY,
	idPermiso INT NOT NULL,
	nombreGrupo NVARCHAR(30) NOT NULL,
	habilitado BIT NOT NULL DEFAULT 1
	CONSTRAINT FK_Permisos_Grupos FOREIGN KEY (idPermiso) REFERENCES Permisos(idPermiso)
);


-- Crear la tabla Lotes
IF OBJECT_ID('Lotes', 'U') IS NULL
CREATE TABLE Lotes(
	idLote INT IDENTITY(1,1) PRIMARY KEY,
	idImprenta INT NOT NULL,
	fechaImpresion DATE NOT NULL,
	cantidadMangas INT NOT NULL,
	CONSTRAINT FK_Imprenta_Lotes FOREIGN KEY (idImprenta) REFERENCES Imprentas(idImprenta),
)


-- Crear tabla DetalleLotes
IF OBJECT_ID('DetalleLotes', 'U') IS NULL
CREATE TABLE DetalleLotes(
	idDetalleLote INT IDENTITY(1,1) PRIMARY KEY,
	idDistribuidor INT NOT NULL,
	idLote INT NOT NULL
	CONSTRAINT FK_DetalleDist_Lotes FOREIGN KEY (idLote) REFERENCES Lotes(idLote),
	CONSTRAINT FK_DetalleDist_Dist FOREIGN KEY (idDistribuidor) REFERENCES Distribuidores(idDistribuidor)
)

-- Crear tabla Sucursales
IF OBJECT_ID('Sucursales', 'U') IS NULL
CREATE TABLE Sucursales(
	idSucursal INT IDENTITY (1,1) PRIMARY KEY,
	idUbicacion INT NOT NULL,
	idDistribuidor INT NOT NULL,
	nombreSuc NVARCHAR(30) NOT NULL,
	direccionSuc NVARCHAR(50) NOT NULL,
	telefonoSuc NVARCHAR(15) NOT NULL,
	CONSTRAINT FK_Sucursales_Distribuidores FOREIGN KEY (idDistribuidor) REFERENCES Distribuidores(idDistribuidor)
)

-- Crear la tabla Prestamos
IF OBJECT_ID('Prestamos', 'U') IS NULL
CREATE TABLE Prestamos (
    idPrestamo INT IDENTITY(1,1) PRIMARY KEY,
	idSucursal INT NOT NULL,
    idUsuario INT NOT NULL,
    totalMangas INT NOT NULL,
    fechaPres DATE NOT NULL,
    fechaDevSR DATE NOT NULL,
    fechaDev DATE NULL,
    estadoPre NVARCHAR(20) NOT NULL DEFAULT 'Aceptado',
    CONSTRAINT FK_Prestamos_Usuarios FOREIGN KEY (idUsuario) REFERENCES Usuarios(idUsuario),
	CONSTRAINT FK_Prestamos_Sucursales FOREIGN KEY (idSucursal) REFERENCES Sucursales(idSucursal)
);


-- Crear la tabla Autores
IF OBJECT_ID('Autores', 'U') IS NULL
CREATE TABLE Autores (
	idAutor INT IDENTITY(1,1) PRIMARY KEY,
    idArtista INT NOT NULL,
	idManga INT NOT NULL,
	idGuionista INT NOT NULL,
	CONSTRAINT FK_Autores_Artistas FOREIGN KEY (idArtista) REFERENCES Artistas(idArtista),
	CONSTRAINT FK_Autores_Guionistas FOREIGN KEY (idGuionista) REFERENCES Guionistas(idGuionista)
);


--Crear la tabla Traductores
IF OBJECT_ID('Traductores','U') IS NULL
CREATE TABLE Traductores (
	idTraductor INT IDENTITY(1,1) PRIMARY KEY,
	idEditorial INT NOT NULL,
	nombreTrad NVARCHAR(50) NOT NULL,
	idiomas NVARCHAR(100) NOT NULL,
	CONSTRAINT FK_Traductores_Editoriales FOREIGN KEY (idEditorial) REFERENCES Editoriales(idEditorial)
);

-- Crear la tabla UbicacionFisica
IF OBJECT_ID('UbicacionFisica', 'U') IS NULL
CREATE TABLE UbicacionFisica (
    idUbicacion INT IDENTITY(1,1) PRIMARY KEY,
	idSucursal INT NOT NULL,
    seccion NVARCHAR(10) NOT NULL,
	pasillo NVARCHAR(5) NOT NULL,
	estanteria INT NOT NULL,
	CONSTRAINT FK_Ubicaciones_Sucursales FOREIGN KEY (idSucursal) REFERENCES Sucursales(idSucursal)
);

-- Crear la tabla Mangas
IF OBJECT_ID('Mangas', 'U') IS NULL
CREATE TABLE Mangas (
    idManga INT IDENTITY(1,1) PRIMARY KEY,
	idGenero INT NOT NULL,
    idUbicacion INT NOT NULL, 
	idEditorial INT NOT NULL,
	idAutor INT NOT NULL,
	idTraductor INT NOT NULL,
    nombreManga NVARCHAR(50) NOT NULL,
    capituloManga INT NULL,
    paginasManga INT NULL,
    imagenManga NVARCHAR(200) DEFAULT 'libro-default.jpg',
    stock INT NOT NULL DEFAULT 1,
    habilitado BIT NOT NULL DEFAULT 1,
    disponible INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Mangas_Generos FOREIGN KEY (idGenero) REFERENCES Generos(idGenero),
    CONSTRAINT FK_Mangas_UbicacionFisica FOREIGN KEY (idUbicacion) REFERENCES UbicacionFisica(idUbicacion),
	CONSTRAINT FK_Mangas_Editoriales FOREIGN KEY (idEditorial) REFERENCES Editoriales(idEditorial),
	CONSTRAINT FK_Mangas_Autores FOREIGN KEY (idAutor) REFERENCES Autores(idAutor),
	CONSTRAINT FK_Mangas_Traductores FOREIGN KEY (idTraductor) REFERENCES Traductores(idTraductor)
);

-- Crear la tabla Apartados
IF OBJECT_ID('Apartados', 'U') IS NULL
CREATE TABLE Apartados (
    idApartado INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario INT NOT NULL,
    idManga INT NOT NULL,
    fechaApartado DATE NOT NULL,
	fechaLimite DATE NOT NULL,  -- Fecha límite para realizar el préstamo
   	estado NVARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    CONSTRAINT FK_Apartados_Usuarios FOREIGN KEY (idUsuario) REFERENCES Usuarios(idUsuario),
    CONSTRAINT FK_Apartados_Mangas FOREIGN KEY (idManga) REFERENCES Mangas(idManga)
);

-- Crear la tabla Detalle Prestamos
IF OBJECT_ID('DetallePrestamos', 'U') IS NULL
CREATE TABLE DetallePrestamos (
    idDetallePrestamo INT IDENTITY(1,1) PRIMARY KEY,
    idPrestamo INT NOT NULL,
    idManga INT NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT FK_DetallePrestamos_Prestamos FOREIGN KEY (idPrestamo) REFERENCES Prestamos(idPrestamo),
    CONSTRAINT FK_DetallePrestamos_Mangas FOREIGN KEY (idManga) REFERENCES Mangas(idManga)
);

--Fin del Script



-- Eliminar Tablas
DROP TABLE Permisos;
DROP TABLE Grupos;
DROP TABLE DetallePrestamos;
DROP TABLE Prestamos;
DROP TABLE Apartados;
DROP TABLE Usuarios;
DROP TABLE Mangas;
DROP TABLE Generos;
DROP TABLE Sucursales;
DROP TABLE Autores;
DROP TABLE Guionistas;
DROP TABLE Artistas;
DROP TABLE Traductores;
DROP TABLE Editoriales;
DROP TABLE DetalleLotes;
DROP TABLE Distribuidores;
DROP TABLE Lotes;
DROP TABLE Imprentas;
DROP TABLE UbicacionFisica;
