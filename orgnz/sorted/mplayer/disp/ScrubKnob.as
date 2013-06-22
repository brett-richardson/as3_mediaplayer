package orgnz.sorted.mplayer.disp {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// Library resources
	import lib.Scrub_Knob;
	
	/**
	 * @author Brett Richardson
	 */
	

	public class ScrubKnob extends Sprite {
		
		private var bmKnob:Bitmap;
		
		
		public function ScrubKnob() {
			buttonMode = false;
			draw();
		}
		
		
		private function draw() {
			if ( bmKnob ) removeChild( bmKnob );
			
			bmKnob = new Bitmap( new Scrub_Knob( 0, 0 ) );
			bmKnob.x = bmKnob.y = -7;
			addChild( bmKnob );
		}
		
	}
	
}