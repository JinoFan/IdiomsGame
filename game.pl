ReadIdiom("IdiomPY.txt"); #读文件
print "网页中的成语显示为红色，输出的成语存放在相关等级对应的文本文件中:\n";
$level=GetLevel();#得到用户输入的等级                                        
main();#根据用户输入的等级生成不同的成语填充                                                   
sub main{	
	if($level == 1){#等级1
	  open(Out1, ">answer1.txt" );
	  @array = level1();
	  PrintAnswer();
	  open(Out, ">level1.html" );
	  printout(Out,@array);	
	}
	elsif($level == 2){#等级2
	  open(Out1, ">answer2.txt" );
	  @array = level2();
	  PrintAnswer();
	  open(Out, ">level2.html" );
	  printout(Out,@array);	
	}
	elsif($level == 3){#等级3
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
   my($filename)=@_;#传参数
   open(In,"$filename");
   while(<In>){
       chomp;
	   @ArrayHZ=();#初始化一个数组,用于存放成语中的汉字，每次循环重新初始化一次
	   if(/(\S+)\s+(\S+)/){#模式匹配  找出所有形如  爱憎分明 ai4_zeng1_fen1_ming2 的字符串 用()提取其中的成语
		$Idiom=$1;#取出成语
		@ArrayHZ=$Idiom=~/../g;#该语句取出成语中的每个汉字存入数组@ArrayHZ
	   }
	   for ($i=0;$i<@ArrayHZ;$i++){#遍历数组
	     my($HZ) = $ArrayHZ[$i];
		 push(@{$HashHZ{$Idiom}},$HZ);#分别以每一个成语为关键字构建值为数组的哈希$HashHZ{$Idiom}，并将该成语中含有的汉字依次存入这个数组中   
		 $hash_HZ{$HZ} = 1;#生成文件中所有成语包含的汉字的表，保证稍后存入数组@ArrHZ中时无重复的汉字            
		 $num = $i;#刚处理的字在成语中的下标                       
		 my(@HzInIdiom);
		 push(@HzInIdiom,$num);
		 push(@HzInIdiom,$Idiom);#将汉字所在的成语及汉字在成语中的下标存入数组@HzInIdiom
		 push(@{$HashIdiom{$HZ}},\@HzInIdiom);#以汉字为关键字构建值为数组的哈希，将@HzInIdiom存入这个哈希，即先构建一个值为数组的哈希，再向这个数组中添加元素，添加的元素也是数组
	   }
   }
   close(In);
   @ArrHZ = sort keys %hash_HZ;#遍历哈希的关键字,取出所有成语中所含的汉字将其存入数组@ArrHZ
}
sub GetLevel{#得到用户想要的等级
	print "请正确输入游戏的等级（在1--3中选择）:";
	$level=<stdin>;
	chomp($level);
	if($level=~/[1-3]/){
		return $level;
	}
	else{
		print "输入不正确\n";
	    return GetLevel();#若用户输入等级不符合要求则重新输入
	}
}
sub printout{
	my ($out,@array)=@_;#传参,printout(Out,@array);	                               
	print $out "<html>\n";
	print $out "<head><style>input{width:28px;font-size:24px;font-family:\"楷体\";color:blue;}#font{font-size:18px;font-family:\"楷体\";}</style></head>";#答案框以及提交框的设定
	print $out "<body style=\"font-family:楷体\">\n";
	print $out "<table align=\"center\" border=\"3\" style=\"font-size: 24px\">\n";
	$num=@array;
	print  Out1 "本次填充共计$num个成语\n";
	$Arr=$array[0];# @array为二维数组的数组,$array[0]相当于C中的指针用于访问二维数组的元素，即在level1(),level2(),level3()中起到重要作用的$array1，实际上@array中的每个元素均为$array1,在这个程序中用@array计数
	for($i = 0; $i<7; $i++){#遍历二维数组
	  for($j = 0; $j < 7; $j++){
		$position=$i*7+$j;#用输出顺序的下标记录汉字位置
		if($Arr->[$i][$j]=~/../){#如果二维数组的元素是汉字
	    $hashpos{$position}=1;#将以位置为关键字的哈希置值为1，作为标记
		}
	  }
	}
	$count=0;#统计设置的空格数
	for($i = 0; $i<7; $i++){#这次遍历用于输出html文件
	  print $out "<tr>\n";
	  for($j = 0; $j < 7; $j++){
		$position=$i*7+$j;#得到汉字的位置
		if($hashpos{$position}==1){#如果该位置为汉字，则输出对应的二维数组的元素
		  if($position%4==0){#当$isspace为3时，则设空
		    print $out "<td style=\"color:red\"><input type=\"text\" id=\"$count\" name=\"$Arr->[$i][$j]\"></td>\n";#name设为字，供js部分使用
			$count++;
		  }
		  else{
			print $out "<td style=\"color:red\">$Arr->[$i][$j]</td>\n";#其他的照常输出成语的字
		  }
		}
		else{#如果该位置不是汉字，则输出随机字到表格
		  my($No) = int(rand()*@ArrHZ)%@ArrHZ;
		  my($HZ) =@ArrHZ[$No];
		  print $out "<td>$HZ</td>\n";
		}
	  }
	  print $out "</tr>\n";
	}
	print $out "</table>\n</br>\n";
	#以下为交互实现的部分用js实现
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
		alert(\"你已经答对了\"+correct+\"个填空！你还有\"+rest+\"个填空没有正确回答，再试试看哦~\");\n
	  }\n
	  else if(correct==sum){\n
		alert(\"恭喜你，你答对了全部\"+sum+\"个填空\");\n
	  }\n
	}\n
    </script>\n";
	print $out "<div align=\"center\"><button onclick=\"check()\"><div id=\"font\">提交答案</div></button></div>\n";
	print $out "</body>\n";
	print $out "</html>";
}
sub one{#返回了一个数组，该数组元素为同一个成语的4个字
	my($No) = int(rand()*@ArrHZ)%@ArrHZ;#在@ArrHZ中随机取一个字的下标
	my($HZ) =@ArrHZ[$No];#取出汉字
	my($No2) = int(rand()*@{$HashIdiom{$HZ}})%@{$HashIdiom{$HZ}};#随机取一个@{$HashIdiom{$HZ}的下标，该数组中的元素为$HZ所在的某个成语和$HZ在该成语中的下标组成的数组
	push(@IdiomArray,${${$HashIdiom{$HZ}}[$No2]}[1]);# ${$HashIdiom{$HZ}}[$No2]为取出的数组，${${$HashIdiom{$HZ}}[$No2]}[1]是一个含有$HZ成语 
	return @{$HashHZ{${${$HashIdiom{$HZ}}[$No2]}[1]}}; # $HashHZ{${${$HashIdiom{$HZ}}[$No2]}[1]}是一个值为数组的哈希,这个数组为成语${${$HashIdiom{$HZ}}[$No2]}[1]的几个字组成的数组
}
sub PrintAnswer{#将成语输出到文本文件中
	for($i = 0; $i<@IdiomArray; $i++){
	  if(${$HashHZ{$IdiomArray[$i]}}[0]=~/../){#判定是否是成语，因为在设置等级时有一部分空格添加进了@IdiomArray数组
	    print Out1 $IdiomArray[$i];
	    print Out1 "\n";
	  }
	}
}
sub HeadRowIdiom{#随机生成一个与表中已有成语无关的成语并横向输出,两个参数分别为成语的第一个字所在的行和列的下标(实际上在这个程序中仅用于生成第一个成语)
	@HzInIdiom = one();#随机取一个成语
	$array1;#用于访问二维数组
	my($row,$col)=@_;#传参数，分别为第一个成语第一个字所在的行和列的下标
	for($i = 0; $i<4; $i++){
	  $array1->[$row][$col++]=@HzInIdiom[$i];#依次给二维数组的元素赋值
	}
	$hashidiom{$IdiomArray[@IdiomArray-1]}=1;#将这个成语作为关键字的哈希赋值为1表示已经选用过，避免之后再选的成语与这个成语重复
	push(@Array1,$array1);
}
sub HeadColIdiom{#随机生成一个与表中已有成语无关的成语并横向输出
	@HzInIdiom = one();
	$array1;#用于访问二维数组
	my($row,$col)=@_;#传参数，分别为第一个成语第一个字所在的行和列的下标
	for($i = 0; $i<4; $i++){
	  $array1->[$row++][$col]=@HzInIdiom[$i];
	}
	$hashidiom{$IdiomArray[@IdiomArray-1]}=1;#将这个成语作为关键字的哈希赋值为1表示已经选用过，避免之后再选的成语与这个成语重复
	push(@Array1,$array1);
}
sub NextRowIdiom{#以选定成语的选定的字为参照，取一个含这个字并且位置合适的成语横向输出
	my($row,$col,$pos)=@_;#传参数，分别为这个成语的第一个字所在的行和列的下标以及这个成语与选定的参照成语相同的字在这个成语中的下标
	$i=0;
	foreach $ele(@{$HashIdiom{$HZ}}){
	  $i++;
	  if($hashidiom{${$ele}[1]}!=1 and ${$ele}[0]==$pos){#如果选到的成语之前未被选用过并且字的下标也正确 
		$NextIdiom = ${$ele}[1];
		@HzInIdiom2=@{$HashHZ{$NextIdiom}};
		for($i = 0; $i<4; $i++){
		  $array1->[$row][$col++]=@HzInIdiom2[$i];
		}
		push(@IdiomArray,$NextIdiom);
		$hashidiom{$NextIdiom}=1;
		push(@Array1,$array1);
		last;#如果找到符合要求的成语则退出循环
	  }
	  elsif($i==@{$HashIdiom{$HZ}}){#否则将" "压入数组,因为之后还要按理论下标继续取成语,这样可以使后面的程序正常运行不受影响
		push(@IdiomArray," ");
	  }
	}
}
sub NextColIdiom{#以选定成语的选定的字为参照，取一个含这个字并且位置合适的成语纵向输出
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
sub level1{#等级1理论上最多可以生成4个成语，具体要视实际情况而定                             
	@IdiomArray=();
	@Array1=();#No.1 @Array1为二维数组的数组，实际作用为计算输出的成语数
	HeadRowIdiom(3,3);#No.1成语
	$HZ=$HzInIdiom[0];
	NextColIdiom(3,3,0);#No.2成语
	$HZ=$HzInIdiom[3];
	NextColIdiom(3,6,0);#No.3成语
	$HZ=$HzInIdiom[3];
	NextColIdiom(0,6,3);#No.4成语
	return @Array1;
}
sub level2{#等级2理论上最多可以生成10个成语，具体要视实际情况而定
	@Array1=level1();#运行一次等级1，将得到的数组赋值给@Array1
	while(@Array1<4){#当等级1生成的成语数小于4时，则重新运行等级1，避免等级间没有区分度的情况
	  @Array1=level1();
	}
	@HzInIdiom=@{$HashHZ{$IdiomArray[1]}};
	for($t=1;$t<3;$t++){
	  $HZ=$HzInIdiom[$t];
	  NextRowIdiom(3+$t,2,1);#No.5--No.6成语
	}
	@HzInIdiom=@{$HashHZ{$IdiomArray[3]}};
	$HZ=$HzInIdiom[0];
	NextRowIdiom(0,3,3);#No.7成语
	@HzInIdiom=@{$HashHZ{$IdiomArray[1]}};
	$HZ=$HzInIdiom[3];
	NextRowIdiom(6,2,1);#No.8成语
	@HzInIdiom=@{$HashHZ{$IdiomArray[3]}};
	for($t=1;$t<3;$t++){
	  $HZ=$HzInIdiom[$t];
	  NextRowIdiom($t,3,3);#No.9--No.10成语
	}
	return @Array1;
}
sub level3{#等级3理论上最多可以生成15个成语，具体要视实际情况而定
	@Array1=level2();#运行一次二级，返回一个数组
	for($t=0;$t<2;$t++){#生成No.11-#No.14成语
	  HeadColIdiom(0,$t);#No.11 和 No.13成语
	  @HzInIdiom=@{$HashHZ{$IdiomArray[@IdiomArray-1]}};
	  $HZ=$HzInIdiom[3];
	  NextColIdiom(3,$t);#No.12 和 No.14成语
	}
	HeadColIdiom(0,2);#生成No.15成语
	return @Array1;
}
