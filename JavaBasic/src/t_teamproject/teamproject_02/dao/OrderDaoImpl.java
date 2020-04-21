package t_teamproject.teamproject_02.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.StringTokenizer;

import t_teamproject.teamproject_02.config.Configuration;
import t_teamproject.teamproject_02.vo.Product;

public class OrderDaoImpl implements OrderDao{
	public OrderDaoImpl() throws ClassNotFoundException {
		Class.forName("oracle.jdbc.driver.OracleDriver");
	}
	public int insertOrder(String productStringList [], ArrayList<Product> calProductList) {
		int result=0;
		Connection con = null;
		String productNameList[] = new String[productStringList.length];
		int productIdList[] = new int[productStringList.length];
		int productCountList[] = new int[productStringList.length];
		int totalPrice=0;
		for(int i=0; i<productStringList.length; i++)
		{
			StringTokenizer st = new StringTokenizer(productStringList[i]);
			productNameList[i] = st.nextToken(); //이걸 id로 바꿔야됨
			productCountList[i] = Integer.parseInt(st.nextToken());
			totalPrice+=Integer.parseInt(st.nextToken());
		}
		for(int i=0; i<productNameList.length; i++) //제품이름리스트에서 제품 아이디리스트를 가져옴
		{
			for(int j=0; j<calProductList.size(); j++)
			{
				if(productNameList[i].equals(calProductList.get(j).getName()))
				{
					productIdList[i]=calProductList.get(j).getId();
				}
			}
		}
		try {
			con = DriverManager.getConnection(Configuration.url, Configuration.user, Configuration.password);
			String sqlToOrderList = "INSERT INTO ORDERLIST(OLID, TOTALPRICE) VALUES(ORDERLIST_OLID.NEXTVAL, ?)";
			PreparedStatement ps1 = con.prepareStatement(sqlToOrderList);
			ps1.setInt(1, totalPrice);
			ps1.executeUpdate();
			ps1.close();
			for(int i=0; i<productStringList.length; i++) {
				String sqlToOrdered = "INSERT INTO ORDERED(OID, PID, OCNT, ODATE, OLID) VALUES(ORDERED_OID.NEXTVAL, ?, ?, SYSDATE, ORDERLIST_OLID.CURRVAL)";
				PreparedStatement ps2 = con.prepareStatement(sqlToOrdered);
				ps2.setInt(1, productIdList[i]);
				ps2.setInt(2, productCountList[i]);
				ps2.executeUpdate();
				ps2.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				con.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return result;
	}
}
