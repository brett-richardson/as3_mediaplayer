package orgnz.sorted.mplayer.disp {
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.display.LineScaleMode;
	
	import orgnz.sorted.mplayer.WindowManager;
	
	// Library assets
	import lib.ControlBar_bg;
	
	
	/**
	 * @author Brett Richardson
	 */
	
	public class ControlBar extends Sprite {
		
		public var		
		spPlayButton	:PlayButton, 
		spScrubber		:Scrubber, 
		spTimer			:Timer,
		spVolume		:Sprite, 
		spFullscreen	:Sprite;
		
		public var
		bmBg			:BitmapData;
		
		
		
		public function ControlBar() {
			WindowManager.dStage.addEventListener( Event.RESIZE, onResize );
			WindowManager.dStage.addEventListener( Event.ACTIVATE, onResize );
			
			spPlayButton = new PlayButton();
			addChild( spPlayButton );
			
			spScrubber = new Scrubber();
			addChild( spScrubber );
			
			spTimer = new Timer();
			addChild( spTimer );
			
			spVolume = new VolumeButton();
			addChild( spVolume );
		}
		
		
		private function drawBg():void {
			graphics.clear();
			var mTransform:Matrix = new Matrix();
			mTransform.translate( 0, WindowManager.dStage.stageHeight - 25 );
			
			bmBg = new ControlBar_bg( 0, 0 );
			
			graphics.lineStyle( 1, 0xb1b1b1, 1, true, LineScaleMode.NONE );
			graphics.beginBitmapFill( bmBg, mTransform, true, true );
			graphics.drawRect(
				0, WindowManager.dStage.stageHeight - 25, 
				WindowManager.dStage.stageWidth - 2, 23
			);
			graphics.endFill();
		}
		
		
		private function onResize( event:Event ):void {
			drawBg();
			placeButtons();
			spScrubber.onResize( WindowManager.dStage.stageWidth - 142 );
		}
		
		
		private function placeButtons() {	
			spPlayButton.y = WindowManager.dStage.stageHeight - 25;
			
			spScrubber.x = spPlayButton.x + 39;
			spScrubber.y = WindowManager.dStage.stageHeight - 17;
			
			spTimer.x = WindowManager.dStage.stageWidth - 90;
			spTimer.y = WindowManager.dStage.stageHeight - 22;
			
			spVolume.x = WindowManager.dStage.stageWidth - 30;
			spVolume.y = WindowManager.dStage.stageHeight - 20;
		}
	}	
}