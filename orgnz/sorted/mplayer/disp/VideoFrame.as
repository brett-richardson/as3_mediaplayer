package orgnz.sorted.mplayer.disp {
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Video;
	
	import orgnz.sorted.mplayer.Chapter;
	import orgnz.sorted.mplayer.WindowManager;
	import orgnz.sorted.mplayer.Streamer;
	
	/**
	 * @author Brett Richardson
	 */
	
	public class VideoFrame extends Sprite {
		
		private var
		aChapters	:Array;
		
		public var 		
		dVideo		:DisplayObject,
		chCurrent	:Chapter;
		
		
		public function VideoFrame() {
			addEventListener( Event.ADDED, onAdded );
		}
		
		
		public function showChapter( chObj:Chapter, bPlay:Boolean = true, nPos = 0 ) {
			if ( chObj !== chCurrent && dVideo /*&& getChildIndex( dVideo )*/ ) {
				trace( 'current chapter detected and being removed.' );
				dVideo.content.stop();
				removeChild( dVideo );
			}
			
			chCurrent = chObj;
			dVideo = chObj.uLoader;
			addChild( dVideo );
			resizeVideo();
			
			if ( !nPos ) nPos = 0;
			
			if ( !dVideo.content ) {
				return trace( 'No dVideo content? Can not show chapter yet.' );
			} else {
				trace( 'Content property found on dVideo.' );
				dVideo.content.stop();
			}
			
			if ( bPlay ) {
				trace( 'VideoFrame.showChapter & playing' );
				dVideo.content.gotoAndPlay( Math.ceil( nPos * chObj.nFrames ) );
				chCurrent.play();
			} else {
				trace( 'VideoFrame.showChapter & NOT playing' );
				dVideo.content.gotoAndStop( Math.ceil( nPos * chObj.nFrames ) );
				chCurrent.stop();
			}
		}
		
		
		private function resizeVideo( event:Event = undefined ) {
			if ( !dVideo || !dVideo.width || !dVideo.height ) return;
			
			var nScale :Number = Math.max( 
				stage.stageWidth / chCurrent.nProperWidth, 
				stage.stageHeight / chCurrent.nProperHeight 
			); 
			dVideo.scaleX = dVideo.scaleY = nScale;
			
			var nXOverlap	:Number 	= dVideo.width - stage.stageWidth,
				nYOverlap	:Number		= dVideo.height - stage.stageHeight;
			
			dVideo.x = 0;
			dVideo.y = 0;
		}
		
		
		private function onAdded( event:Event ) {
			stage.addEventListener( Event.RESIZE, resizeVideo );
			stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		
		private function onEnterFrame( event:Event ) {
			try {
				if ( chCurrent.mcContainer.currentFrame == chCurrent.mcContainer.totalFrames ) {
					nextChapter();
				}
			} catch ( e:Error ){}
		}
		
		
		public function nextChapter() {
			trace( 'Next chapter now!' );
			var bNext	:Boolean = false,
				nCount	:Number = 0;
			
			if ( WindowManager.spVideoFrame.chCurrent === Streamer.aLoadItems[ Streamer.aLoadItems.length - 1 ] ) {
				chCurrent.stop();
				showChapter( Streamer.aLoadItems[0], false );
				WindowManager.spControlBar.spPlayButton.bPlaying = false;
				WindowManager.spControlBar.spPlayButton.setupIcon();
				return;
			}
			
			for each( var chapter:Chapter in Streamer.aLoadItems ) {
				trace( 'Chapter:' + nCount + ' / ' + Streamer.aLoadItems.length );
				
				if ( bNext ) {
					trace( 'Playing next chapter: ' + chapter.sTitle );
					WindowManager.spVideoFrame.showChapter( chapter );
					chapter.activate();
					chapter.play();
					bNext = false;
					break;
				}
				
				if ( chapter === WindowManager.spVideoFrame.chCurrent ) {
					bNext = true;
				}
				nCount++;
			}
		}
	}
	
}