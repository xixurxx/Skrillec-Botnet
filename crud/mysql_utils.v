/**********************************************
*  Making easier function for MySQL to use!   *
**********************************************/
module crud

import mysql

/*
        MySQL Function For Users
*/

/* This function reads all users from mySQL DB */
pub fn grab_user_info(mut s mysql.Connection, user string) []string {
        s.connect() or { panic("[x] Error, Failed to connect to MySQL!") }
        q_resp := s.query('SELECT * FROM users WHERE username=\'${user}\'') or { panic("Unable to send query to MySQL!") }
        mut row := []string
        for i in q_resp.maps() {
	        if i['username'] == user {
                        row << i['username']
                        row << i['ip']
                        row << i['password']
                        row << i['level']
                        row << i['maxtime']
                        row << i['conn']
                        row << i['ongoing']
                        row << i['admin']
                        row << i['expiry']
		}
        }
        q_resp.free()
        s.close()
        return row
}

// edit(svr.sqlconn, "root", "lvl=3");
pub fn edit_user(mut s mysql.Connection, user string, set string) int {
        // UPDATE users SET lvl=3 WHERE username='root';
        s.connect() or { return 0, "" }
        q_resp := s.query('UPDATE users SET ${set} WHERE username=\'root\'')
        print(q_resp)
        if q_resp != none {
                return 1
        }
        q_resp.free()
        s.close()
        return 0
}

/*
        MySQL Functions for APIs
*/
/* This function reads all api_name from mySQL DB */
pub fn grab_api_info(mut s mysql.Connection, api_name string) []string {
        s.connect() or { panic("[x] Error, Failed to connect to MySQL!") }
        q_resp := s.query('SELECT * FROM apis WHERE username=\'${api_name}\'') or { panic("Unable to send query to MySQL!") }
        mut row := []string
        for i in q_resp.maps() {
	        if i['api_name'] == api_name {
                        row << i['id']
                        row << i['api_name']
                        row << i['api_url']
                        row << i['api_methods']
		}
        }
        q_resp.free()
        s.close()
        return row
}

/*
        method ->               row_counter(s mysql.Connection, table string)
        return type ->          exit_code(int), row_count(int)
        note ->                 exit_code is 0 if the table wasnt found!
*/
pub fn row_counter(mut s mysql.Connection, table string) (int, int) {
        s.connect() or { return 0, 0 }
        q_res := s.query("SELECT COUNT(*) FROM ${table}") or { return 0, 0 }
        for i in q_res.maps() {
                return 1, i["COUNT(*)"].int()
        }
        q_res.free()
        s.close()
        return 0, 0
}