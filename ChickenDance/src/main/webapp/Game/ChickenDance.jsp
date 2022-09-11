<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
*{
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}
body{
	background: skyblue;
    height: 100%;
    overflow: hidden;
    
    background-image: url(../source/image/헤네시스.png);
    background-attachment: fixed;
	background-size: cover;
	background-repeat: no-repeat;
	background-position: center bottom;
}
.warp{
	width: 100vw;
	height: 100vh;
}
.container1{
	width: 100%;
	height: 35%;
	top: 0;
	position:relative;
	z-index: 5;
}
.container2{
	width: 100%;
	height: 65%;
	top: 0;
	position:relative;
	z-index: 1;
	/* 
	background-image: url(../source/image/그림1.png);
	background-size: contain;
	background-repeat: no-repeat;
	background-position: center bottom;
	 */
}
.danceGame{
	position: absolute;
	height:75px;
	width:801px;
	top: 0;
	bottom:0;
	left:0;
	right:0;
	margin-top:auto;
	margin-bottom:auto;
	margin-left:auto;
	margin-right:auto;
}
.fritoimg{
	position: absolute;
	height: 100%;
	top: 0;
	bottom:0;
	left:0;
	right:0;
	margin-top:auto;
	margin-bottom: 0;
	margin-left:auto;
	margin-right:auto;
}
.arrowImg{
	width:75px;
	height:75px;
}
.score{
	position: absolute;
	width: 300px;
	height:120px;
	top: 0;
	bottom:0;
	left:0;
	right:0;
	margin-top:auto;
	margin-bottom:0;
	margin-left:auto;
	margin-right:auto;
}
scoreStyle1{
	font-family: '돋움';
	font-size: 2em;
	color: white;
}
scoreStyle2{
	font-family: '맑은 고딕';
	font-size: 2em;
	font-weight: 600;
	color: #FFBB00;
}
scoreTime1{
	font-family: '돋움';
	font-size: 2em;
	float: right;
	color: white;
}
scoreTime2{
	font-family: '맑은 고딕';
	font-size: 2em;
	font-weight: 600;
	color: #FF5E00;
	float: right;
}
</style>
<script type="text/javascript">
	var lap = 0;

	var image = [
			[ "../source/image/left.png", "../source/image/left2.png", "../source/image/left_.png" ],
			[ "../source/image/up.png", "../source/image/up2.png", "../source/image/up_.png" ],
			[ "../source/image/right.png", "../source/image/right2.png", "../source/image/right_.png", ],
			[ "../source/image/down.png", "../source/image/down2.png", "../source/image/down_.png" ]];
	//화살관련 변수
	var arrow = [ [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
			[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ];
	
	var index = 0;
	
	var time = 0;
	var maxtime = 999999999;

	var recode = [0,0,0,0,0,0,0,0,0,0]; // 시간기록
	
	var typo = [0,0,0,0,0,0,0,0,0,0]; // 시도횟수 
	
	// 기록계산(기록평균)
	function recodeAvg(){
		var sum = 0;
		var count = 0;
		for(var i = 0; i < recode.length; i++){
			if(recode[i] == 0) continue;
			sum += recode[i];
			count++;
		}
		if(sum + count == 0) return "기록없음";
		return ((sum/count)/1000).toFixed(2);
	}
	
	// 정확도 계산(모든 시도횟수를 더해서 10으로 나눈것(안틀릴경우 10/10 으로 100%)) 
	function typoAvg(){
		var sum = 0;
		var count = 0;
		for(var i = 0; i < typo.length; i++){
			if(typo[i] == 0) continue;
			sum += typo[i];
			count++;
		}
		if(sum + count == 0) return 0;
		return (count/sum * 100).toFixed(2);
	}
	
	//이미지를띄우는 메서드
	function displayImage(src, alt) {
		var a = document.createElement("img");
		a.src = src;
		a.alt = "" + alt;
		a.height = 100;
		a.width = 100;
		document.body.appendChild(a);
	}

	function randomSet() {
		for (var i = 0; i < arrow[0].length; i++) {
			arrow[0][i] = randomNum();
			arrow[1][i] = 0;
		}
	}

	function randomNum() {
		return Math.floor(Math.random() * 4);
	}

	function printImage(i) {
		document.getElementById("arrow_"+i).src = image[arrow[0][i]][arrow[1][i]];
	}
	
	function setGame(){
		document.getElementById("recode").innerHTML = recodeAvg()+"'s";
		lap++;
		document.getElementById("lap").innerHTML = lap;
		index = 0;
		randomSet();
		for (var i = 0; i < arrow[0].length; i++) {
			printImage(i);
		}
	}
	
	//키입력부
	document.addEventListener("keydown", checkKeyPressed, false);


	function checkKeyPressed(e) {
		
		if (e.keyCode == 37){
			isColl(0);
		}
		if (e.keyCode == 38){
			isColl(1);
		}
		if (e.keyCode == 39){
			isColl(2);
		}
		if (e.keyCode == 40){
			isColl(3);
		}
	}
	
	function isColl(num){
		//첫 시도일 경우
		if(time == 0){
			typo[lap % typo.length] = 0; //초기화
			time = new Date().getTime();
		}
		
		// 맞았을 때
		if(arrow[0][index] == num){
			arrow[1][index] = 1;
			printImage(index);
			index++;
			// 끝까지 다쳤을 때
			if(index == arrow[0].length){
				typo[lap % typo.length]++;
				document.getElementById("typo").innerHTML = typoAvg()+"%";
				// 시간 기록
				time = new Date().getTime() - time;
				recode[lap % recode.length] = time;
				// 최고기록 일때
				if(time < maxtime){
					maxtime = time;
					document.getElementById("highrecord").innerHTML = maxtime/1000 + "'s ";
				}
				document.getElementById("time").innerHTML = "" + time/1000 + "'s ";
				time = 0;
				// 다음판 불러오기
				setTimeout(function() {
					setGame();
				}, 300);
			}
		}
		// 틀렸을 때
		else{
			typo[(lap - 1) % typo.length]++; //시도횟수 증가
			document.getElementById("typo").innerHTML = typoAvg()+"%";
			
			if(lap == 1)
				document.getElementById("typo").innerHTML = "0 %";
			
			for(; index < arrow[0].length; index++){
				arrow[1][index] = 2;
				printImage(index);
			}
			setTimeout(function() {
				for(var n = 0; n < arrow[0].length; n++){
					arrow[1][n] = 0;
					printImage(n);
				}
				index = 0;
			}, 300);
		}
	}

	
	
	
	
</script>
<meta charset="UTF-8">
<title>프리토 닭춤 연습</title>
</head>
<body>
	<div class="warp">
		<div class="container1">
			<p><lap id="lap">0</lap> lap</p>
			<p>평균시간 <recode id="recode">(기록없음)</recode></p>
			<p>정확도 <typo id="typo">(기록없음)</typo></p>
			
			<div class="danceGame">
			 <img id="arrow_0" class="arrowImg">
			 <img id="arrow_1" class="arrowImg">
			 <img id="arrow_2" class="arrowImg">
			 <img id="arrow_3" class="arrowImg">
			 <img id="arrow_4" class="arrowImg">
			 <img id="arrow_5" class="arrowImg">
			 <img id="arrow_6" class="arrowImg">
			 <img id="arrow_7" class="arrowImg">
			 <img id="arrow_8" class="arrowImg">
			 <img id="arrow_9" class="arrowImg">
			</div>
		</div>
		
		<div class="container2">
			<div class="score">
				<scoreStyle1>걸린시간 : </scoreStyle1>
				<scoreTime1 id="time"></scoreTime1>
				<br>
				<scoreStyle2>최대기록 : </scoreStyle2>
				<scoreTime2 id="highrecord"></scoreTime2>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		setGame();
	</script>
	</body>
</html>