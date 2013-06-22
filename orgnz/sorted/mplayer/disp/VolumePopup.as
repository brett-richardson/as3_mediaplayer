package orgnz.sorted.mplayer.disp {
	
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import fl.transitions.TweenEvent;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import orgnz.sorted.mplayer.WindowManager;
	
	// Library assets
	import lib.VolumeKnob;
	
	
	/**
	 * @author Brett Richardson
	 */
	
	
	public class VolumePopup extends Sprite {
		
		public var
		spVolumeKnob	:Sprite,
		bDragging		:Boolean = false,
		twFade			:Tween;
		
		
		
		public function VolumePopup() {
			spVolumeKnob = new VolumeKnob();
			spVolumeKnob.buttonMode = true;
			spVolumeKnob.y = height / -6;
			addChild( spVolumeKnob );
			
			setBehaviour();
		}
		
		
		public function fadeOut() {
			twFade = new Tween( this, 'alpha', Strong.easeOut, 1, 0, 1, true );
		}
		
		
		private function setBehaviour() {
			spVolumeKnob.addEventListener( MouseEvent.MOUSE_DOWN, onKnobClick );
		}
		
		
		private function onKnobClick( event:MouseEvent ) {
			spVolumeKnob.startDrag(
				true,
				new Rectangle(
					spVolumeKnob.x, ( height / -2 ) + spVolumeKnob.height / 2,
					0, height - ( spVolumeKnob.height )
				)
			);
			stage.addEventListener( MouseEvent.MOUSE_UP, onKnobUnclick, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, onKnobUnclick, false, 0, true );
		}
		
		
		private function onKnobUnclick( event:MouseEvent ) {
			spVolumeKnob.stopDrag();
			
			SoundMixer.soundTransform = new SoundTransform( 
				0.9 - ( ( spVolumeKnob.y + height / 2 ) / height )
			);
			
			stage.removeEventListener( MouseEvent.CLICK, onKnobUnclick );
			stage.removeEventListener( MouseEvent.MOUSE_UP, onKnobUnclick );
		}
		
	}
	
}