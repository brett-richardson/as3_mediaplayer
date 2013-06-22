package orgnz.sorted.mplayer {
	import fl.transitions.easing.Strong;
	import fl.transitions.Tween;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import orgnz.sorted.mplayer.disp.ChapterMarker;
	import orgnz.sorted.mplayer.Streamer;
	
	/**
	 * @author Brett Richardson
	 */
	
	
	public class Chapter {
		
		public var 		
		sTitle			:String, 
		sDesc			:String, 
		sUrl			:String,
		sExt			:String,
		nProperWidth	:Number,
		nProperHeight	:Number,
		nLoadPerc		:Number, 
		nFrames			:Number, 
		nSeconds		:Number, 
		nBytes			:Number,
		uLoader			:Loader,
		bPlayOnLoad		:Boolean = false,
		bPlaying		:Boolean = false,
		mcContainer		:MovieClip,
		twEase			:Tween,
		mMarker			:ChapterMarker;
		
		
		
		public function Chapter( xmlConfig:XML ) {			
			sTitle = xmlConfig.title;
			sDesc = xmlConfig.description;
			sUrl = xmlConfig.file;
			sExt = xmlConfig.file.@type;
			nProperWidth = xmlConfig.width;
			nProperHeight = xmlConfig.height;
			nFrames = xmlConfig.length.frames;
			
			uLoader = new Loader();
			uLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgress );
			uLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onComplete );
			uLoader.contentLoaderInfo.addEventListener( Event.INIT, onInit );
		}
		
		
		public function activate() {
			trace( 'Acticate function called!' );
			for each( var chChap:Chapter in Streamer.aLoadItems ) {
				if ( chChap === this ) continue;
				
				chChap.stop();
			}
			
			WindowManager.spVideoFrame.showChapter( this );
			bPlaying = true;
		}
		
		
		public function stop() {
			bPlaying = false;
			if ( mcContainer && mcContainer.stop() ){
				with ( WindowManager.spControlBar.spPlayButton ) {
					bPlaying = false;
					setupIcon();
				}
			}
		}
		
		
		public function play() {
			bPlaying = true;
			if ( mcContainer && mcContainer.play() ) { 
				WindowManager.spControlBar.spPlayButton.bPlaying = false;
				WindowManager.spControlBar.spPlayButton.dispatchEvent( new MouseEvent( MouseEvent.CLICK ) );
			}
		}
		
		
		public function seek( nPos:Number ) {
			trace( 'Seeking to: ' + nPos ); // :D Emily is this bitchenist chick ever she is so cool.
			if ( mcContainer ) {
				if ( WindowManager.spControlBar.spPlayButton.bPlaying ) {
					mcContainer.gotoAndPlay( Math.ceil( nPos * mcContainer.totalFrames ) );
				} else {
					mcContainer.gotoAndStop( Math.ceil( nPos * mcContainer.totalFrames ) );
				}
			}
		}
		
		
		private function onProgress( event:ProgressEvent ) {
			if ( event.bytesLoaded / event.bytesTotal == 1 ) {
				twEase.stop();
				nLoadPerc = 1;
			} else {
				if ( twEase ) {
					twEase.continueTo( event.bytesLoaded / event.bytesTotal, 12 );
				} else {
					twEase = new Tween( 
						this, 'nLoadPerc', Strong.easeInOut, 
						nLoadPerc, event.bytesLoaded / event.bytesTotal,
						12, false
					);
				}
			}
		}
		
		
		private function onComplete( event:Event ) {
			nLoadPerc = 1;
			twEase = null;
		}
		
		
		private function onInit( event:Event ) {
			trace( uLoader.contentLoaderInfo.width + ' x ' + uLoader.height );
			mcContainer = uLoader.content;
			mcContainer.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		
		public function beginDownload() {
			uLoader.load( 
				new URLRequest( 
					sUrl + '?q=' + Math.floor( Math.random() * 1000 ) 
				) 
			);
		}
		
		
		private function onEnterFrame( event:Event ) {
			if ( bPlaying ) {
				play();
				// TODO: There must be a better way to do this?!
			} else {
				stop();
			}
		}
		
	}
	
}