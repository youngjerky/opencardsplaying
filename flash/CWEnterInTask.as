﻿package
{
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.system.*;
	public class CWEnterInTask{
		private var ip:String;
		private var port:int;
		private var playerName:String;
		private var socket:Socket;
		private var debugInfo:TextField;
		private var succeedFun:Function;
		private var failFun:Function;
		private var playerEnterFun:Function;
		
		public function CWEnterInTask(ip:String,port:int,playerName:String){
			this.socket = new Socket();
			this.ip = ip;
			this.port = port;
			this.playerName = playerName;
			this.debugInfo = null;
			socket.addEventListener(Event.CONNECT,connectHandler);
			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		public function setDebugInfo(debugInfo:TextField):void{
			this.debugInfo = debugInfo;
		}
		
		public function startTask():void{
			socket.connect(ip,port);
		}
		
		public function setSucceedAndFailFunction(succeedFun:Function,failFun:Function):void{
			this.succeedFun = succeedFun;
			this.failFun = failFun;
		}
		
		public function setPlayerEnterFunction(playerEnterFun:Function):void{
			this.playerEnterFun = playerEnterFun;
		}
		
		private function connectHandler(event:Event):void{
			showDebugInfo(event.toString());
			socket.writeUTF("enter,"+playerName+",");
			socket.flush();
		}
		
		private function socketDataHandler(event:ProgressEvent):void{
			showDebugInfo(event.toString());
			var bufferString:String = socket.readUTFBytes(socket.bytesAvailable);
			showDebugInfo(bufferString);
			var requestArray:Array = bufferString.split(",");
			trace(requestArray.length);
			for(var i:uint = 0;i<requestArray.length-1;i++){
				trace("i=" + i);
				showDebugInfo(requestArray[i]);
				if (requestArray[i] == "success"){
					var index:int = requestArray[i+1];
					trace(index);
					if(succeedFun!=null)
						this.succeedFun(index);
					i++;
				}
				else if(requestArray[i] == "failed"){
					if(this.failFun!=null)
						this.failFun(-1);
				}
				else if(requestArray[i] == "playerenter"){
					var playerEnterName:String = requestArray[i+1];
					var playerEnterIndex:int = requestArray[i+2];
					if(this.playerEnterFun!=null){
						this.playerEnterFun(playerEnterName, playerEnterIndex);
					}
					i = i+2;
				}
			}
			socket.close();
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			showDebugInfo(event.toString());
			socket.close();
    	}

    	private function securityErrorHandler(event:SecurityErrorEvent):void {
			showDebugInfo(event.toString());
			socket.close();
    	}
		
		private function closeHandler(event:Event):void {
			showDebugInfo(event.toString());
			socket.close();
    	}
		
		private function showDebugInfo(info:String):void {
			if(debugInfo!=null){
				debugInfo.text = info;
			}
			trace(info);
		}
	}
}
