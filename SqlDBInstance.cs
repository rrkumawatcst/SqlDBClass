using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Configuration;

namespace SchedularApp.SqlDBClass
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
            con.Close();                                         // always close the conneciton
        }

        private static string getConnectionString()
        {
            return "";       // here we set connection string from web.config file
        }


        /// <summary>
        /// this funciton use for get data from database by passing simple command
        /// eg.
        ///         cmsString = "select stdName , stdAddress from tblStudent";
        /// </summary>
        /// <param name="cmdString">cmsString = "select stdName , stdAddress from tblStudent";</param>
        /// <returns>it Return a Datatable which contain the number of rows according to command</returns>
        public DataTable getDatatable(string cmdString)
        {
            try
            {
                dt = new DataTable();
                con.Open();
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
            finally
            {
                con.Close();
                con.Dispose();
            }
        }

        /// <summary>
        /// this function use to retrive data from database with multiple parameter values
        /// the values stored in hashtable
        /// </summary>
        /// <param name="prName">Procedure Name like : : prgetStudentInfoByName</param>
        /// <param name="ht">parameter store in : : ht["stName"] = "Ram"</param>
        /// <returns></returns>
        public DataTable getDatatable(string prName, Hashtable ht)
        {
            try
            {
                dt = new DataTable();
                con.Open();
                lock (prName)
                {
                    //
                    // Create SQL Command
                    //
                    cmd = new SqlCommand()
                    {
                        Connection = con,
                        CommandText = prName,
                        CommandType = CommandType.StoredProcedure
                    };
                    //
                    // MAP hashtable ht to stored procedure parameters using ICollection Interface...
                    //
                    ICollection keys = ht.Keys;
                    foreach (String k in keys)
                    {
                        cmd.Parameters.AddWithValue("@" + k, ht[k]);
                    }

                    //
                    // data retrive from execute command
                    //
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
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
    }
}
