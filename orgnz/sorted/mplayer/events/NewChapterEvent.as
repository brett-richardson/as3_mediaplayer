package orgnz.sorted.mplayer.events {
	import flash.events.Event;
	import orgnz.sorted.mplayer.Chapter;
	
	/**
	 * @author Brett Richardson
	 */
	
	public class NewChapterEvent extends Event {
		
		public static const
		NEW_CHAPTER		:String = 'orgnz.sorted.mplayer.events.NewChapterEvent::NEW_CHAPTER';
		
		public var
		chNew			:Chapter;
		
		public function NewChapterEvent( chNew:Chapter ) {
			this.chNew = chNew;
			super( NEW_CHAPTER );
		}
		
	}
	
}