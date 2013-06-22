package orgnz.sorted.mplayer.disp {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import orgnz.sorted.mplayer.WindowManager;
	
	// Library resources
	import lib.Icon_Pause;
	import lib.Icon_Play;
	
	/**
	 * @author Brett Richardson
	 */
	
	
	public class PlayButton extends Sprite {
		
		public var 		
		bPlaying	:Boolean = false;
		
		private var
		bmIcon		:Bitmap;
		
		
		public function PlayButton() {
			addEventListener( MouseEvent.CLICK, onClick );
			addEventListener( Event.ENTER_FRAME, onEnterFrame );
			buttonMode = true;
			
			createOutline();
			setupIcon();
		}
		
		
		public function setupIcon():void {
			if ( bmIcon ) removeChild( bmIcon );
			
			if( bPlaying ){
				bmIcon = new Bitmap( new Icon_Pause( -2, 0 ) );
			} else {
				bmIcon = new Bitmap( new Icon_Play( 0, 0 ) );
			}
			bmIcon.x = 9;
			bmIcon.y = 5;
			
			addChild( bmIcon );
		}
		
		
		private function createOutline():void {
			with ( graphics ) {
				clear();
				lineStyle( 1, 0xb1b1b1, 1, true, LineScaleMode.NONE );
				beginFill( 0xFF0000, 0 );
				drawRect( 0, 0, 30, 23 );
				endFill();
			}
		}
		
		
		private function onClick( event:Event ) {
			trace( 'Click play pause!?' );
			
			if ( bPlaying ) {
				trace( 'think its playing already.' );
				WindowManager.spVideoFrame.chCurrent.stop();
			} else {
				trace( 'thinking its not playing' );
				WindowManager.spVideoFrame.chCurrent.play();
			}
			
			bPlaying = !bPlaying;
			setupIcon();
		}
		
		
		private function onEnterFrame( event:Event ) {
			if ( 
				WindowManager.spVideoFrame.chCurrent &&
				WindowManager.spVideoFrame.chCurrent.bPlaying
			) {
				bPlaying = true;
				setupIcon();
			}
		}
	}
	
}