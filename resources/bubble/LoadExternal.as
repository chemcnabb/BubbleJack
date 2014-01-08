/*
Copyright (c) 2007, George Wang, neatfilm.com
All rights reserved. Release under BSD License.
*/

// Created: George Wang, 3 Feb 2007. 

// This is the method I used in my Squirrel Bubble Game (http://www.neatfilm.net) 
// to load external assets dynamically.
package{
	import flash.display.Sprite;
	import com.neatfilm.display.AssetLoader;
	
	public class LoadExternal extends Sprite
	{
		private var assets:Array;
		private var loadId:int;
		private var loadFlag:Boolean;
		
		public function LoadExternal()
		{
			this.assets = [['sound.swf']];	// urls of all external swfs files
			init();
		}
		private function init():void
		{
			this.loadId = 0;
			this.loadFlag = true;
			load();
		}
		private function load():void
		{
			var a:AssetLoader = new AssetLoader(this.assets[this.loadId],this.loadId,this,'loadAsset');
		}
		public function loadAsset(ref:*, id:int):void
		{
			this.assets[id].push(ref);	// the reference will be pushed into 
										// this.assets[id][1] so you can use
										// then anytime;
			switch(id){		// asset load ready events dispatch
				case 0:
				thisAssetReady(this.assets[id][1]);
				break;
				default:
				trace('Wrong id: '+id);
			}
		}
		private function thisAssetReady(ref:*)
		{
			ref[2].play();	// play a sound loop of it.
		}
	}
	
}