import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

public class InfectStatisticWeb {
	
	public static JSONArray spider() {
		
		try {
			String line;
			 
			URL url = new URL("https://lab.isaaclin.cn//nCoV/api/area?latest=1");
			//URL url = new URL("https://ncov.dxy.cn/ncovh5/view/pneumonia");
			//skip security check on website,ignored
			
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
	        connection.setDoInput(true);
	        connection.setRequestMethod("GET");
	        connection.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 5.0; Windows NT; DigExt)");
			BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(),"utf-8"));
			StringBuilder sbBuilder = new StringBuilder();
			
			while ((line = br.readLine()) != null) {
				sbBuilder.append(line);
			}
			br.close();
			connection.disconnect();
			
			//开始进行信息筛选，获得result转化为array
			JSONObject jsonObject = JSONObject.parseObject(sbBuilder.toString());
			JSONArray array = JSONArray.parseArray(jsonObject.get("results").toString());

			return array;
		}
		catch (Exception e) {
		    e.printStackTrace();
		    return null;
		}
	}
	
	public static JSONObject dealDate() {
		
		JSONArray needArray = new JSONArray();
		JSONObject needObj = new JSONObject();
		JSONArray array = spider();
		
		if(array == null) {
			return null;
		}
		
		int size = array.size();
		for (int i = 0; size > i; i++) {
			
			JSONObject jo1 = (JSONObject)array.get(i);
			
			if (jo1.get("countryName").toString().equals("中国")) {
				//jo1.put("name", jo1.getString("provinceShortName"));
				//	jo1.put("value", jo1.getString("currentConfirmedCount"));
				needObj.put(jo1.getString("provinceShortName"), jo1);
			}
		}
		
		return needObj;
	}

}
