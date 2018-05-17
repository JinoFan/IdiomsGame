ReadIdiom("IdiomPY.txt"); #���ļ�
print "��ҳ�еĳ�����ʾΪ��ɫ������ĳ���������صȼ���Ӧ���ı��ļ���:\n";
$level=GetLevel();#�õ��û�����ĵȼ�                                        
main();#�����û�����ĵȼ����ɲ�ͬ�ĳ������                                                   
sub main{	
	if($level == 1){#�ȼ�1
	  open(Out1, ">answer1.txt" );
	  @array = level1();
	  PrintAnswer();
	  open(Out, ">level1.html" );
	  printout(Out,@array);	
	}
	elsif($level == 2){#�ȼ�2
	  open(Out1, ">answer2.txt" );
	  @array = level2();
	  PrintAnswer();
	  open(Out, ">level2.html" );
	  printout(Out,@array);	
	}
	elsif($level == 3){#�ȼ�3
	  open(Out1, ">answer3.txt" );
	  @array = level3();
	  PrintAnswer();
	  open(Out, ">level3.html" );
	  printout(Out,@array);	
	}
	Out.close();
	Out1.close();
}
sub ReadIdiom{
   my($filename)=@_;#������
   open(In,"$filename");
   while(<In>){
       chomp;
	   @ArrayHZ=();#��ʼ��һ������,���ڴ�ų����еĺ��֣�ÿ��ѭ�����³�ʼ��һ��
	   if(/(\S+)\s+(\S+)/){#ģʽƥ��  �ҳ���������  �������� ai4_zeng1_fen1_ming2 ���ַ��� ��()��ȡ���еĳ���
		$Idiom=$1;#ȡ������
		@ArrayHZ=$Idiom=~/../g;#�����ȡ�������е�ÿ�����ִ�������@ArrayHZ
	   }
	   for ($i=0;$i<@ArrayHZ;$i++){#��������
	     my($HZ) = $ArrayHZ[$i];
		 push(@{$HashHZ{$Idiom}},$HZ);#�ֱ���ÿһ������Ϊ�ؼ��ֹ���ֵΪ����Ĺ�ϣ$HashHZ{$Idiom}�������ó����к��еĺ������δ������������   
		 $hash_HZ{$HZ} = 1;#�����ļ������г�������ĺ��ֵı���֤�Ժ��������@ArrHZ��ʱ���ظ��ĺ���            
		 $num = $i;#�մ�������ڳ����е��±�                       
		 my(@HzInIdiom);
		 push(@HzInIdiom,$num);
		 push(@HzInIdiom,$Idiom);#���������ڵĳ��Ｐ�����ڳ����е��±��������@HzInIdiom
		 push(@{$HashIdiom{$HZ}},\@HzInIdiom);#�Ժ���Ϊ�ؼ��ֹ���ֵΪ����Ĺ�ϣ����@HzInIdiom���������ϣ�����ȹ���һ��ֵΪ����Ĺ�ϣ������������������Ԫ�أ���ӵ�Ԫ��Ҳ������
	   }
   }
   close(In);
   @ArrHZ = sort keys %hash_HZ;#������ϣ�Ĺؼ���,ȡ�����г����������ĺ��ֽ����������@ArrHZ
}
sub GetLevel{#�õ��û���Ҫ�ĵȼ�
	print "����ȷ������Ϸ�ĵȼ�����1--3��ѡ��:";
	$level=<stdin>;
	chomp($level);
	if($level=~/[1-3]/){
		return $level;
	}
	else{
		print "���벻��ȷ\n";
	    return GetLevel();#���û�����ȼ�������Ҫ������������
	}
}
sub printout{
	my ($out,@array)=@_;#����,printout(Out,@array);	                               
	print $out "<html>\n";
	print $out "<head><style>input{width:28px;font-size:24px;font-family:\"����\";color:blue;}#font{font-size:18px;font-family:\"����\";}</style></head>";#�𰸿��Լ��ύ����趨
	print $out "<body style=\"font-family:����\">\n";
	print $out "<table align=\"center\" border=\"3\" style=\"font-size: 24px\">\n";
	$num=@array;
	print  Out1 "������乲��$num������\n";
	$Arr=$array[0];# @arrayΪ��ά���������,$array[0]�൱��C�е�ָ�����ڷ��ʶ�ά�����Ԫ�أ�����level1(),level2(),level3()������Ҫ���õ�$array1��ʵ����@array�е�ÿ��Ԫ�ؾ�Ϊ$array1,�������������@array����
	for($i = 0; $i<7; $i++){#������ά����
	  for($j = 0; $j < 7; $j++){
		$position=$i*7+$j;#�����˳����±��¼����λ��
		if($Arr->[$i][$j]=~/../){#�����ά�����Ԫ���Ǻ���
	    $hashpos{$position}=1;#����λ��Ϊ�ؼ��ֵĹ�ϣ��ֵΪ1����Ϊ���
		}
	  }
	}
	$count=0;#ͳ�����õĿո���
	for($i = 0; $i<7; $i++){#��α����������html�ļ�
	  print $out "<tr>\n";
	  for($j = 0; $j < 7; $j++){
		$position=$i*7+$j;#�õ����ֵ�λ��
		if($hashpos{$position}==1){#�����λ��Ϊ���֣��������Ӧ�Ķ�ά�����Ԫ��
		  if($position%4==0){#��$isspaceΪ3ʱ�������
		    print $out "<td style=\"color:red\"><input type=\"text\" id=\"$count\" name=\"$Arr->[$i][$j]\"></td>\n";#name��Ϊ�֣���js����ʹ��
			$count++;
		  }
		  else{
			print $out "<td style=\"color:red\">$Arr->[$i][$j]</td>\n";#�������ճ�����������
		  }
		}
		else{#�����λ�ò��Ǻ��֣����������ֵ����
		  my($No) = int(rand()*@ArrHZ)%@ArrHZ;
		  my($HZ) =@ArrHZ[$No];
		  print $out "<td>$HZ</td>\n";
		}
	  }
	  print $out "</tr>\n";
	}
	print $out "</table>\n</br>\n";
	#����Ϊ����ʵ�ֵĲ�����jsʵ��
	print $out "<script language=javascript>\n
	var count=$count;\n
	function check(){\n
	  sum=parseInt(count);\n 
	  var answer=new Array();\n
	  var personanswer=new Array();\n
	  for(i=0;i<sum;i++){\n
	  answer[i]=document.getElementById(String(i)).name;\n
	  personanswer[i]=document.getElementById(String(i)).value;\n
	}\n
	  var correct=0;\n
	  for(i=0;i<sum;i++){\n
	    if(answer[i]==personanswer[i]){\n
		  correct++;\n
	    }\n
	  }\n
	  if(correct<sum){\n
		rest=sum-correct;\n
		alert(\"���Ѿ������\"+correct+\"����գ��㻹��\"+rest+\"�����û����ȷ�ش������Կ�Ŷ~\");\n
	  }\n
	  else if(correct==sum){\n
		alert(\"��ϲ�㣬������ȫ��\"+sum+\"�����\");\n
	  }\n
	}\n
    </script>\n";
	print $out "<div align=\"center\"><button onclick=\"check()\"><div id=\"font\">�ύ��</div></button></div>\n";
	print $out "</body>\n";
	print $out "</html>";
}
sub one{#������һ�����飬������Ԫ��Ϊͬһ�������4����
	my($No) = int(rand()*@ArrHZ)%@ArrHZ;#��@ArrHZ�����ȡһ���ֵ��±�
	my($HZ) =@ArrHZ[$No];#ȡ������
	my($No2) = int(rand()*@{$HashIdiom{$HZ}})%@{$HashIdiom{$HZ}};#���ȡһ��@{$HashIdiom{$HZ}���±꣬�������е�Ԫ��Ϊ$HZ���ڵ�ĳ�������$HZ�ڸó����е��±���ɵ�����
	push(@IdiomArray,${${$HashIdiom{$HZ}}[$No2]}[1]);# ${$HashIdiom{$HZ}}[$No2]Ϊȡ�������飬${${$HashIdiom{$HZ}}[$No2]}[1]��һ������$HZ���� 
	return @{$HashHZ{${${$HashIdiom{$HZ}}[$No2]}[1]}}; # $HashHZ{${${$HashIdiom{$HZ}}[$No2]}[1]}��һ��ֵΪ����Ĺ�ϣ,�������Ϊ����${${$HashIdiom{$HZ}}[$No2]}[1]�ļ�������ɵ�����
}
sub PrintAnswer{#������������ı��ļ���
	for($i = 0; $i<@IdiomArray; $i++){
	  if(${$HashHZ{$IdiomArray[$i]}}[0]=~/../){#�ж��Ƿ��ǳ����Ϊ�����õȼ�ʱ��һ���ֿո���ӽ���@IdiomArray����
	    print Out1 $IdiomArray[$i];
	    print Out1 "\n";
	  }
	}
}
sub HeadRowIdiom{#�������һ����������г����޹صĳ��ﲢ�������,���������ֱ�Ϊ����ĵ�һ�������ڵ��к��е��±�(ʵ��������������н��������ɵ�һ������)
	@HzInIdiom = one();#���ȡһ������
	$array1;#���ڷ��ʶ�ά����
	my($row,$col)=@_;#���������ֱ�Ϊ��һ�������һ�������ڵ��к��е��±�
	for($i = 0; $i<4; $i++){
	  $array1->[$row][$col++]=@HzInIdiom[$i];#���θ���ά�����Ԫ�ظ�ֵ
	}
	$hashidiom{$IdiomArray[@IdiomArray-1]}=1;#�����������Ϊ�ؼ��ֵĹ�ϣ��ֵΪ1��ʾ�Ѿ�ѡ�ù�������֮����ѡ�ĳ�������������ظ�
	push(@Array1,$array1);
}
sub HeadColIdiom{#�������һ����������г����޹صĳ��ﲢ�������
	@HzInIdiom = one();
	$array1;#���ڷ��ʶ�ά����
	my($row,$col)=@_;#���������ֱ�Ϊ��һ�������һ�������ڵ��к��е��±�
	for($i = 0; $i<4; $i++){
	  $array1->[$row++][$col]=@HzInIdiom[$i];
	}
	$hashidiom{$IdiomArray[@IdiomArray-1]}=1;#�����������Ϊ�ؼ��ֵĹ�ϣ��ֵΪ1��ʾ�Ѿ�ѡ�ù�������֮����ѡ�ĳ�������������ظ�
	push(@Array1,$array1);
}
sub NextRowIdiom{#��ѡ�������ѡ������Ϊ���գ�ȡһ��������ֲ���λ�ú��ʵĳ���������
	my($row,$col,$pos)=@_;#���������ֱ�Ϊ�������ĵ�һ�������ڵ��к��е��±��Լ����������ѡ���Ĳ��ճ�����ͬ��������������е��±�
	$i=0;
	foreach $ele(@{$HashIdiom{$HZ}}){
	  $i++;
	  if($hashidiom{${$ele}[1]}!=1 and ${$ele}[0]==$pos){#���ѡ���ĳ���֮ǰδ��ѡ�ù������ֵ��±�Ҳ��ȷ 
		$NextIdiom = ${$ele}[1];
		@HzInIdiom2=@{$HashHZ{$NextIdiom}};
		for($i = 0; $i<4; $i++){
		  $array1->[$row][$col++]=@HzInIdiom2[$i];
		}
		push(@IdiomArray,$NextIdiom);
		$hashidiom{$NextIdiom}=1;
		push(@Array1,$array1);
		last;#����ҵ�����Ҫ��ĳ������˳�ѭ��
	  }
	  elsif($i==@{$HashIdiom{$HZ}}){#����" "ѹ������,��Ϊ֮��Ҫ�������±����ȡ����,��������ʹ����ĳ����������в���Ӱ��
		push(@IdiomArray," ");
	  }
	}
}
sub NextColIdiom{#��ѡ�������ѡ������Ϊ���գ�ȡһ��������ֲ���λ�ú��ʵĳ����������
	my($row,$col,$pos)=@_;
	$i=0;
	foreach $ele(@{$HashIdiom{$HZ}}){
	  $i++;
	  if($hashidiom{${$ele}[1]}!=1 and ${$ele}[0]==$pos){  
		$NextIdiom = ${$ele}[1];
		@HzInIdiom2=@{$HashHZ{$NextIdiom}};
		for($i = 0; $i<4; $i++){
		  $array1->[$row++][$col]=@HzInIdiom2[$i];
		}
		push(@IdiomArray,$NextIdiom);
		$hashidiom{$NextIdiom}=1;
		push(@Array1,$array1);
		last;
	  }
	  elsif($i==@{$HashIdiom{$HZ}}){
		push(@IdiomArray," ");
	  }
	}
}
sub level1{#�ȼ�1����������������4���������Ҫ��ʵ���������                             
	@IdiomArray=();
	@Array1=();#No.1 @Array1Ϊ��ά��������飬ʵ������Ϊ��������ĳ�����
	HeadRowIdiom(3,3);#No.1����
	$HZ=$HzInIdiom[0];
	NextColIdiom(3,3,0);#No.2����
	$HZ=$HzInIdiom[3];
	NextColIdiom(3,6,0);#No.3����
	$HZ=$HzInIdiom[3];
	NextColIdiom(0,6,3);#No.4����
	return @Array1;
}
sub level2{#�ȼ�2����������������10���������Ҫ��ʵ���������
	@Array1=level1();#����һ�εȼ�1�����õ������鸳ֵ��@Array1
	while(@Array1<4){#���ȼ�1���ɵĳ�����С��4ʱ�����������еȼ�1������ȼ���û�����ֶȵ����
	  @Array1=level1();
	}
	@HzInIdiom=@{$HashHZ{$IdiomArray[1]}};
	for($t=1;$t<3;$t++){
	  $HZ=$HzInIdiom[$t];
	  NextRowIdiom(3+$t,2,1);#No.5--No.6����
	}
	@HzInIdiom=@{$HashHZ{$IdiomArray[3]}};
	$HZ=$HzInIdiom[0];
	NextRowIdiom(0,3,3);#No.7����
	@HzInIdiom=@{$HashHZ{$IdiomArray[1]}};
	$HZ=$HzInIdiom[3];
	NextRowIdiom(6,2,1);#No.8����
	@HzInIdiom=@{$HashHZ{$IdiomArray[3]}};
	for($t=1;$t<3;$t++){
	  $HZ=$HzInIdiom[$t];
	  NextRowIdiom($t,3,3);#No.9--No.10����
	}
	return @Array1;
}
sub level3{#�ȼ�3����������������15���������Ҫ��ʵ���������
	@Array1=level2();#����һ�ζ���������һ������
	for($t=0;$t<2;$t++){#����No.11-#No.14����
	  HeadColIdiom(0,$t);#No.11 �� No.13����
	  @HzInIdiom=@{$HashHZ{$IdiomArray[@IdiomArray-1]}};
	  $HZ=$HzInIdiom[3];
	  NextColIdiom(3,$t);#No.12 �� No.14����
	}
	HeadColIdiom(0,2);#����No.15����
	return @Array1;
}
