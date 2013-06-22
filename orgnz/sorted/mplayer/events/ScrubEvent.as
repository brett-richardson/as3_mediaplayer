package orgnz.sorted.mplayer.events {
	import flash.events.Event;
	import orgnz.sorted.mplayer.Chapter;
	
	/**
	 * @author Brett Richardson
	 */
	
	public class ScrubEvent extends Event {
		
		public const	
		SCRUBBED		:String = 'orgnz.sorted.mplayer.events.ScrubEvent::scrub';
		
		public var 		
		nPosition		:Number,
		nChapterPos		:Number,
		chItem			:Chapter;
		
		public function ScrubEvent( type:String,bubbles:Boolean, cancelable:Boolean, nPosition:Number = undefined, chItem:Chapter = undefined, nChapterPos:Number = undefined ) {
            this.nPosition = nPosition;
			this.chItem = chItem;
			this.nChapterPos = nChapterPos;
			
			super( type, bubbles, cancelable );
        }
		
	}
	
}