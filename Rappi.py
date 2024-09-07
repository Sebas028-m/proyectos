import tkinter as tk
from tkinter import ttk, messagebox
import mysql.connector


class BaseTab(tk.Frame):
    def __init__(self, parent, db_config, table_name, columns, column_names):
        super().__init__(parent)
        self.db_config = db_config
        self.table_name = table_name
        self.columns = columns
        self.column_names = column_names
        self.create_widgets()

    def create_widgets(self):
        info_frame = tk.LabelFrame(self, text=f"Información de {self.table_name.capitalize()}", padx=10, pady=10)
        info_frame.pack(padx=5, pady=5)

        self.entries = []
        for i, column_name in enumerate(self.column_names):
            tk.Label(info_frame, text=f"{column_name}:", padx=5, pady=5).grid(row=i, column=0, sticky="e")
            entry = tk.Entry(info_frame, width=30)
            entry.grid(row=i, column=1, padx=5, pady=5, sticky="ew")
            self.entries.append(entry)

        search_button = tk.Button(info_frame, text="Buscar por ID", command=self.search_by_id)
        search_button.grid(row=len(self.column_names), column=0, columnspan=2, pady=10)

        button_frame = tk.Frame(self)
        button_frame.pack(pady=10)

        tk.Button(button_frame, text="Crear", command=self.create).pack(side=tk.LEFT, padx=5)
        tk.Button(button_frame, text="Leer", command=self.read).pack(side=tk.LEFT, padx=5)
        tk.Button(button_frame, text="Actualizar", command=self.update).pack(side=tk.LEFT, padx=5)
        tk.Button(button_frame, text="Eliminar", command=self.delete).pack(side=tk.LEFT, padx=5)

        self.tree = ttk.Treeview(self, columns=self.columns, show="headings")
        for column in self.columns:
            self.tree.heading(column, text=column)
        self.tree.pack(fill=tk.BOTH, expand=True)

        self.load_data()

    def search_by_id(self):
        record_id = self.entries[0].get()
        if not record_id:
            messagebox.showwarning("Advertencia", "Por favor, ingrese un ID para buscar.")
            return

        try:
            connection = mysql.connector.connect(**self.db_config)
            cursor = connection.cursor()

            query = f"SELECT * FROM {self.table_name} WHERE id = %s"
            cursor.execute(query, (record_id,))
            record = cursor.fetchone()

            if record:
                self.populate_fields(record)
            else:
                messagebox.showinfo("Información", f"No se encontró un registro con ese ID en {self.table_name}.")
        except mysql.connector.Error as error:
            messagebox.showerror("Error", f"Error al buscar {self.table_name}: {error}")
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()

    def populate_fields(self, record):
        for i, value in enumerate(record):
            self.entries[i].delete(0, tk.END)
            self.entries[i].insert(0, value)

    def create(self):
        values = [entry.get() for entry in self.entries[1:]]
        if any(not value for value in values):
            messagebox.showwarning("Advertencia", "Por favor, complete todos los campos requeridos.")
            return

        try:
            connection = mysql.connector.connect(**self.db_config)
            cursor = connection.cursor()

            query = f"INSERT INTO {self.table_name} ({', '.join(self.columns[1:])}) VALUES ({', '.join(['%s'] * len(values))})"
            cursor.execute(query, tuple(values))
            connection.commit()
            messagebox.showinfo("Éxito", f"Registro creado con éxito en {self.table_name}.")
            self.load_data()
        except mysql.connector.Error as error:
            messagebox.showerror("Error", f"Error al crear registro en {self.table_name}: {error}")
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()

    def read(self):
        self.search_by_id()

    def update(self):
        record_id = self.entries[0].get()
        values = [entry.get() for entry in self.entries[1:]]
        if not record_id or any(not value for value in values):
            messagebox.showwarning("Advertencia", "Por favor, complete todos los campos requeridos.")
            return

        try:
            connection = mysql.connector.connect(**self.db_config)
            cursor = connection.cursor()

            query = f"UPDATE {self.table_name} SET {', '.join([f'{col} = %s' for col in self.columns[1:]])} WHERE id = %s"
            cursor.execute(query, tuple(values) + (record_id,))
            connection.commit()
            messagebox.showinfo("Éxito", f"Registro actualizado con éxito en {self.table_name}.")
            self.load_data()
        except mysql.connector.Error as error:
            messagebox.showerror("Error", f"Error al actualizar registro en {self.table_name}: {error}")
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()

    def delete(self):
        record_id = self.entries[0].get()
        if not record_id:
            messagebox.showwarning("Advertencia", "Por favor, ingrese un ID para eliminar.")
            return

        try:
            connection = mysql.connector.connect(**self.db_config)
            cursor = connection.cursor()

            query = f"DELETE FROM {self.table_name} WHERE id = %s"
            cursor.execute(query, (record_id,))
            connection.commit()
            messagebox.showinfo("Éxito", f"Registro eliminado con éxito en {self.table_name}.")
            self.load_data()
        except mysql.connector.Error as error:
            messagebox.showerror("Error", f"Error al eliminar registro en {self.table_name}: {error}")
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()

    def load_data(self):
        try:
            connection = mysql.connector.connect(**self.db_config)
            cursor = connection.cursor()

            query = f"SELECT * FROM {self.table_name}"
            cursor.execute(query)
            records = cursor.fetchall()

            self.tree.delete(*self.tree.get_children())
            for record in records:
                self.tree.insert("", "end", values=record)

        except mysql.connector.Error as error:
            messagebox.showerror("Error", f"Error al cargar datos de {self.table_name}: {error}")
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()


class ServiceTypesTab(BaseTab):
    def __init__(self, parent, db_config):
        columns = ("ID", "Descripcion", "Coste")
        column_names = ["ID", "Descripcion", "Coste"]
        super().__init__(parent, db_config, "tipo_servicio", columns, column_names)


class MujeresTab(BaseTab):
    def __init__(self, parent, db_config):
        columns = ("ID", "Nombre", "Edad", "Coste")
        column_names = ["ID", "Nombre", "Edad", "Coste"]
        super().__init__(parent, db_config, "mujeres", columns, column_names)


class ClientesTab(BaseTab):
    def __init__(self, parent, db_config):
        columns = ("ID", "Nombre", "Telefono", "Email")
        column_names = ["ID", "Nombre", "Telefono", "Email"]
        super().__init__(parent, db_config, "clientes", columns, column_names)


class VentasTab(BaseTab):
    def __init__(self, parent, db_config):
        columns = ("ID", "id_mujer", "id_cliente", "fecha", "total")
        column_names = ["ID", "id_mujer", "id_cliente", "fecha", "total"]
        super().__init__(parent, db_config, "ventas", columns, column_names)


# Aquí puedes inicializar la aplicación Tkinter y agregar las pestañas a un contenedor principal
if __name__ == "__main__":
    root = tk.Tk()
    root.title("Gestión de Datos")

    db_config = {
        'user': 'root',
        'password': '1234',
        'host': 'localhost',
        'database': 'base_datos_mujeres'
    }

    notebook = ttk.Notebook(root)
    notebook.add(ServiceTypesTab(notebook, db_config), text="Tipos de Servicio")
    notebook.add(MujeresTab(notebook, db_config), text="Mujeres")
    notebook.add(ClientesTab(notebook, db_config), text="Clientes")
    notebook.add(VentasTab(notebook, db_config), text="Ventas")
    notebook.pack(fill=tk.BOTH, expand=True)

    root.mainloop()
