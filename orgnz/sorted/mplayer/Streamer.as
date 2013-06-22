package orgnz.sorted.mplayer {
	
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent; 
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	
	import orgnz.sorted.mplayer.events.NewChapterEvent;
	import orgnz.sorted.mplayer.Chapter;
	
	
	/**
	 * @author Brett Richardson
	 */
	
	
	public class Streamer {
		
		public static const
		EVENT_LOADED_CHAPTERS	:String = 'ORGNZ.SORTED.MPLAYER.STREAMER::chaptersloaded';
		
		public static var
		eDispatch		:EventDispatcher,
		aLoadItems		:Array;
		
		public var
		nComplete		:Number,
		nTotalTime		:Number,
		chCurrentLoad	:Chapter;
		
		
		
		public function Streamer() {
			eDispatch = new EventDispatcher();
			aLoadItems = new Array();
		}
		
		
		private function listenToChapter( chObj:Chapter ) {
			chObj.uLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onComplete );
			chObj.uLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgress );
			chObj.uLoader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHttpStatus );
			chObj.uLoader.contentLoaderInfo.addEventListener( Event.INIT, onInit );
			chObj.uLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIoError );
		}
		
		
		private function unlistenToChapter( chObj:Chapter ) {
			chObj.uLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onComplete );
			chObj.uLoader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onProgress );
			chObj.uLoader.contentLoaderInfo.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onHttpStatus );
			chObj.uLoader.contentLoaderInfo.removeEventListener( Event.INIT, onInit );
			chObj.uLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onIoError );
		}
		
		
		private function addChapter( chItem:Chapter ):void {
			aLoadItems.push( chItem );
		}
		
		
		public function addChapters( chArray:* ):void {
			if ( chArray is Chapter ) return addChapter( chArray );
			if ( !chArray is Array ) throw new Error( 'Input must be an array of chapters or a single Chapter object.' );
			
			nTotalTime = 0;
			
			for ( var i = 0; i < chArray.length; i++ ) {
				if ( chArray[i] is Chapter ) {
					if ( i == 0 ) chArray[i].play();
					
					aLoadItems.push( chArray[i] );
					nTotalTime += chArray[i].nFrames;
				}
			}
			
			eDispatch.dispatchEvent( 
				new Event( EVENT_LOADED_CHAPTERS ) 
			);
			
			WindowManager.spControlBar.spScrubber.dispatchEvent( new Event( Event.ACTIVATE ) );
		}
		
		
		public function beginLoad() { // Begin downloading next chapter
			trace( 'Beginning a chapter load' );
			
			chCurrentLoad = undefined;
			
			for each( var chapter:Chapter in aLoadItems ) {
				trace( 'Iterating through chapters:' + chapter.sTitle );
				if ( chapter.nLoadPerc == 1 ) continue;
				
				chCurrentLoad = chapter;
				break;
			}
			
			if ( !chCurrentLoad ) {
				trace( 'No chapters to load!' );
				return false;
			}
			
			chCurrentLoad.beginDownload();
			
			listenToChapter( chCurrentLoad );
			
			trace( 'Dispatching new chapter event' );
			eDispatch.dispatchEvent(
				new NewChapterEvent( chCurrentLoad )
			)
		}
		
		
		private function onComplete( event:Event ) {
			unlistenToChapter( chCurrentLoad );
			chCurrentLoad.nLoadPerc = 1;
			beginLoad();
		}
		
		
		private function onProgress( event:ProgressEvent ) {
			chCurrentLoad.nLoadPerc = event.bytesLoaded / event.bytesTotal;
			chCurrentLoad.nBytes = event.bytesTotal;
			
			//checkStopped();
		}
		
		
		private function onHttpStatus( event:HTTPStatusEvent ) {
		}
		
		
		public function onInit( event:Event ) {
			trace( 'Chapter load: INIT EVENT' );
			
			chCurrentLoad.uLoader.content.stop();
			//checkStopped();
			
			WindowManager.dStage.dispatchEvent( new Event( Event.RESIZE ) );
		}
		
		
		private function onIoError( event:IOErrorEvent ) {
			trace( 'IOError!' );
		}
		
		
		private function checkStopped() {
			for each( var chapter:Chapter in aLoadItems ) {
				if( chapter.mcContainer && !( WindowManager.spVideoFrame.dVideo == chapter.mcContainer && WindowManager.spControlBar.spPlayButton.bPlaying ) ){
					chapter.mcContainer.stop();
				}
			}
		}
	}
	
}