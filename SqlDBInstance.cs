using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;                   //Add System.Data
using System.Data.SqlClient;        //Add System.Data.SqlClient;
using System.Collections;           // Add System.Collection
namespace SqlDBClass
{
    public class SqlDBInstance
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;
        Hashtable ht;

        //Class Constructor For Initilize SQL Database Connection String
        public SqlDBInstance()
        {
            con = new SqlConnection();
            con.ConnectionString = getConnectionString();
        }

        private static string getConnectionString()
        {
            return "";       // here we set connection string from web.config file
        }

        public DataTable getDatatable(string cmdString)
        {
            try
            {
                dt = new DataTable();
                lock (cmdString)
                {
                    cmd = new SqlCommand()
                    {
                        Connection = con,
                        CommandText = cmdString,
                        CommandType = CommandType.Text
                    };

                    sda = new SqlDataAdapter();
                    sda.SelectCommand = cmd;
                    sda.Fill(dt);
                }

                return dt;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

    }
}
