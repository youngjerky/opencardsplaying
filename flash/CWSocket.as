﻿package
{
	import flash.events.*;
	import flash.net.Socket;
	import flash.text.*;
	import flash.system.*;
	public class CWSocket{
		private var socket:Socket;
		private var debugInfo:TextField;
		private var bufferString:String;
		private var gotData:Boolean;
		
		public function CWSocket(){
			socket = new Socket();
			debugInfo = null;
			bufferString = null;
			socket.addEventListener(Event.CONNECT,connectHandler);
			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		public function setDebugInfo(text:TextField):void{
			debugInfo = text;
		}
		
		public function startSocket():void{
			socket.connect("192.168.1.37",2901);
		}
		
		public function dataReady():Boolean{
			return gotData;
		}
		
		public function stringFromServer():String{
			var tmpString:String = bufferString;
			bufferString = null;
			gotData = false;
			return tmpString;
		}
		
		private function connectHandler(event:Event):void{
			showDebugInfo(event.toString());
		}
		
		private function socketDataHandler(event:ProgressEvent):void{
			showDebugInfo(event.toString());
			bufferString = socket.readUTFBytes(socket.bytesAvailable);
			showDebugInfo(bufferString);
			gotData = true;
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			showDebugInfo(event.toString());
    	}

    	private function securityErrorHandler(event:SecurityErrorEvent):void {
			showDebugInfo(event.toString());
    	}
		
		private function closeHandler(event:Event):void {
			showDebugInfo(event.toString());
    	}
		
		private function showDebugInfo(info:String):void {
			if(debugInfo!=null){
				debugInfo.text = info;
			}
			trace(info);
		}
	}
}
