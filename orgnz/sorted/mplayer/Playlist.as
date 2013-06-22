package orgnz.sorted.mplayer {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	import orgnz.sorted.mplayer.Chapter;
	
	/**
	 * @author Brett Richardson
	 */
	
	public class Playlist {
		
		private static var 	
		uLoader			:URLLoader;
		
		private var
		xmlData			:XML;
		
		public static var
		pInst			:Playlist;
		
		public var
		aChapters		:Array,
		sStream			:Streamer,
		nTotalFrames 	:Number;
		
		
		
		
		public function Playlist () {
			pInst = this;
			sStream = new Streamer();
		}
		
		
		public function load( sURL:String ):Playlist {
			uLoader = new URLLoader();
			uLoader.addEventListener( Event.COMPLETE, onXmlLoaded );
			uLoader.load( 
				new URLRequest( 
					sURL + '?q=' + Math.floor( Math.random() * 1000 ) 
				)
			);
			return this;
		}
		
		
		private function onXmlLoaded( event:Event ):void {
			xmlData = new XML( uLoader.data );
			createPlaylistFromXml();
			
			trace( '*** XML LOADED ***' );
			trace( xmlData );
			
			sStream.addChapters( aChapters );
			sStream.beginLoad();
			
			WindowManager.spVideoFrame.showChapter( aChapters[0] );
		}
		
		
		private function createPlaylistFromXml() {
			if ( !xmlData ) throw new Error( 'Can not create playlist without an XML object' );
			
			nTotalFrames = 0;
			aChapters = new Array();
			
			for each( var xmlChapter:XML in xmlData.chapter ) {
				var chNew :Chapter = new Chapter( xmlChapter );
				nTotalFrames += chNew.nFrames;
				aChapters.push( chNew );
			}
			
			WindowManager.spControlBar.spScrubber.setTotalFrames( nTotalFrames );
			
			return aChapters;
		}
		
	}
	
}