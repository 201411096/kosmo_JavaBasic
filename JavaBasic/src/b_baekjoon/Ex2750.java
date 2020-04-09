package b_baekjoon;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Collections;

public class Ex2750{

	public static void main(String[] args) throws IOException{
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(System.out));
		StringBuffer answer= new StringBuffer();
		int intputCase = Integer.parseInt(br.readLine());
		ArrayList<Integer> inputNum = new ArrayList<Integer>();
		for(int i=0; i<intputCase; i++)
		{
			inputNum.add(Integer.parseInt(br.readLine()));
		}
		Collections.sort(inputNum);
		
		for(int i=0; i<inputNum.size(); i++)
			answer.append(Integer.toString(inputNum.get(i))+"\n");
		
		bw.write(answer.toString());
		bw.flush();
		
		br.close();
		bw.close();
	}
}
