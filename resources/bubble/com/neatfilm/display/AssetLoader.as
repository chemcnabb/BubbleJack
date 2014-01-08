/*
Copyright (c) 2007, George Wang, neatfilm.com
All rights reserved. Release under BSD License.
*/

// To load an external SWF and return asset on its library.
// Usage: new AssetLoader( holder, url, id, [caller, callback]);
// 			set callback function as public
//          id: to be used as an argument for callback
// Created: George Wang, 11 Jan 2007. 

package com.neatfilm.display
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Bitmap;

	public class AssetLoader extends Loader
	{
		private var url:String;
		private var callback:String;
		private var caller:*;
		private var id:int;
		
		public function AssetLoader(url:String, id:int, caller:* = undefined, callback:String = null)
		{
			// target: holder display object
			// url: swf url
			// caller.callback: callback function
			super();
			
			this.url = url;
			this.id = id;
			this.callback = callback;
			this.caller = caller;
			init();
		}
		private function init():void
		{
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			var request:URLRequest=new URLRequest(this.url);
			this.load(request);
		}
		private function completeHandler(event:Event):void{
			var asset:* = this.content.getAsset();
			if(Boolean(this.caller))
				this.caller[this.callback](asset, this.id);
		}
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace('Unable to load image: '+ this.url);
		}
	}
}