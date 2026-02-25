import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.Properties;
import java.util.Scanner;

public class BD1 {

	/**
	 * Conexion a la BD.
	 * Global para que se pueda usar en todos los metodos de la clase.
	 */
	static Connection connection;

	public static void main(String args[]) throws Exception {
		Class.forName("oracle.jdbc.driver.OracleDriver");

		// Leer oracle.properties para obtener los datos de conexion a la BD
		Properties oracleProperties = new Properties();
		oracleProperties.load(new FileReader("Oracle.properties"));
		String host = oracleProperties.getProperty("host");
		String port = oracleProperties.getProperty("port");
		String sid = oracleProperties.getProperty("sid");
		String user = oracleProperties.getProperty("user");
		String password = oracleProperties.getProperty("password");

		// Conectarse a la BD
		connection = DriverManager.getConnection(
				"jdbc:oracle:thin:@" + host + ":" + port + ":" + sid, user, password);
		connection.setAutoCommit(true);

		// =============================================================

		if (args.length > 0 && args[0].equals("-c")) {
			dropTables();
			createTables();
			populateTables();
		}

		mainLoop();

		// =============================================================

		connection.close();
	}

	/**
	 * Bucle principal del programa, que lee sentencias SQL de la entrada estandar y
	 * las ejecuta.
	 * El bucle termina cuando el usuario escribe "exit".
	 */
	public static void mainLoop() {
		Scanner sc = new Scanner(System.in);
		String sql = "";
		System.out.println("\033[34mEscribe consultas SQL para ejecutarlas en la BD. 'exit' para salir.\033[0m");

		while (!sql.equalsIgnoreCase("exit")) {
			System.out.print("> ");
			sql = sc.nextLine();
			try {
				executeQuery(sql);
			} catch (Exception e) {
				System.out.println("Error al ejecutar la consulta: " + e.getMessage());
			}
		}
		sc.close();
	}

	// Crear las tablas de la BD. (populate.sql)
	public static void createTables() throws Exception {
		execFile("create.sql");
	}

	// Eliminar las tablas de la BD. (drop.sql)
	public static void dropTables() throws Exception {
		execFile("drop.sql");
	}

	public static void populateTables() throws Exception {
		execFile("populate.sql");
	}

	// Ejecuta todas las sentencias SQL que hay en un fichero, separadas por ';'
	public static void execFile(String filename) throws Exception {
		Scanner sc = new Scanner(new FileReader(filename));
		sc.useDelimiter(";");
		while (sc.hasNext()) {
			String sql = sc.next().trim();
			if (!sql.isEmpty()) {
				executeSentence(sql);
			}
		}
		sc.close();
	}

	// ==================================================

	/**
	 * Metodo para ejecutar una sentencia SQL que no sea una pregunta, es decir,
	 * que no devuelva una tabla como resultado.
	 */
	public static void executeSentence(String sql) throws Exception {
		try {
			connection.createStatement().executeUpdate(sql);
		} catch (Exception e) {
			System.out.println("\033[31mError al ejecutar la sentencia:\n"
					+ sql
					+ "\nerror: " + e.getMessage()
					+ "\033[0m");
		}
	}

	/**
	 * Metodo para realizar una pregunta SQL a la BD (una sentencia SELECT)
	 */
	public static void executeQuery(String sql) throws Exception {
		if (sql.endsWith(";"))
			sql = sql.substring(0, sql.length() - 1);
		ResultSet rs = connection.createStatement().executeQuery(sql);

		// Creamos la cabecera de la tabla de resultados
		ResultSetMetaData rsmd = rs.getMetaData();
		for (int i = 1; i <= rsmd.getColumnCount(); i++) {
			System.out.print(" " + rsmd.getColumnLabel(i) + "\t | ");
		}
		System.out.println();

		// Creamos las filas de la tabla con la informacion de la tuplas obtenidas
		System.out.println("---------------------------------------------------------------------------------------");
		while (rs.next()) {// Por cada tupla
			for (int j = 1; j <= rsmd.getColumnCount(); j++) {
				System.out.print(" " + rs.getString(j) + "\t | ");
			}
			System.out.println();
		}
	}

}

class CSVRow {

	public String inicioTemporada;
	public String finTemporada;
	public String division;
	public String jornada;
	public String equipoLocal;
	public String equipoVisitante;
	public String golesLocal;
	public String golesVisitante;
	public String club;
	public String ciudad;
	public String fundacion;
	public String fundLegal;
	public String nombre;
	public String estadio;
	public String fechaInag;
	public String aforo;
	public String equipo;

	public CSVRow(String raw) {
		String[] fields = raw.split(";");

		this.inicioTemporada = getField(fields, 0);
		this.finTemporada = getField(fields, 1);
		this.division = getField(fields, 2);
		this.jornada = getField(fields, 3);
		this.equipoLocal = getField(fields, 4);
		this.equipoVisitante = getField(fields, 5);
		this.golesLocal = getField(fields, 6);
		this.golesVisitante = getField(fields, 7);
		this.club = getField(fields, 8);
		this.ciudad = getField(fields, 9);
		this.fundacion = getField(fields, 10);
		this.fundLegal = getField(fields, 11);
		this.nombre = getField(fields, 12);
		this.estadio = getField(fields, 13);
		this.fechaInag = getField(fields, 14);
		this.aforo = getField(fields, 15);
		this.equipo = getField(fields, 16);
	}

	private String getField(String[] arr, int index) {
		if (index < arr.length) {
			return arr[index];
		} else {
			return "";
		}
	}
}