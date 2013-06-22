package orgnz.sorted.mplayer.disp {
	import fl.motion.easing.Exponential;
	import fl.transitions.Tween;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import orgnz.sorted.mplayer.WindowManager;
	
	/**
	 * @author Brett Richardson
	 */
	
	public class VolumeButton extends Sprite {
		
		public var
		spPopup		:VolumePopup;
		
		private var
		twPop		:Tween;
		
		
		public function VolumeButton() {
			SoundMixer.soundTransform = new SoundTransform( 0.75 );
			
			buttonMode = true;
			drawHitArea();
			
			addEventListener( MouseEvent.CLICK, onClick );
		}
		
		
		private function onClick( event:MouseEvent ) {
			if( !spPopup ){
				spPopup = new VolumePopup();
				WindowManager.spControlBar.addChild( spPopup );
			} else {
				spPopup.alpha = 1;
			}
			
			spPopup.x = x + spPopup.width / 2;
			spPopup.y = y - spPopup.height / 2;
			
			event.stopPropagation();
			stage.addEventListener( MouseEvent.MOUSE_UP, onStageUnclick );
		}
		
		
		private function onStageUnclick( event:MouseEvent ) {
			if ( spPopup && spPopup.alpha ) {
				spPopup.fadeOut();
			}
			stage.removeEventListener( MouseEvent.CLICK, onStageUnclick );
		}
		
		
		private function drawHitArea() {
			with( graphics ){
				beginFill( 0x000000, 0 );
				drawRect( -2, -2, 26, 20 );
				endFill();
			}
		}
		
	}
	
}