package orgnz.sorted.mplayer.disp {
	import fl.transitions.Tween;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	import orgnz.sorted.mplayer.Chapter;
	import orgnz.sorted.mplayer.Playlist;
	import orgnz.sorted.mplayer.Streamer;
	import orgnz.sorted.mplayer.WindowManager;
	import orgnz.sorted.mplayer.events.ScrubEvent;
	import orgnz.sorted.mplayer.events.NewChapterEvent;
	import orgnz.sorted.mplayer.disp.ScrubKnob;
	import orgnz.sorted.mplayer.disp.ChapterMarker;
	
	//Library resources
	import lib.Scrubber_Bg_Left;
	import lib.Scrubber_Bg_Right;
	import lib.Scrubber_Bg_Downloaded;
	import lib.Scrubber_Bg_Inactive;
	
	/**
	 * @author Brett Richardson
	 */
	
	 
	public class Scrubber extends Sprite {
		
		public var 		
		nTargetWidth	:Number = 337, 
		nInnerWidth		:Number = 327,
		spKnob			:ScrubKnob,
		bDragging		:Boolean = false,
		pList			:Playlist,
		nTotalFrames	:Number = 0,
		nLoadingFrames	:Number = 0,
		aChapterMarkers	:Array;
		
		private var		
		spActive		:Sprite,
		spInactive		:Sprite,
		bmLeftEdge		:Bitmap,
		bmRightEdge		:Bitmap,
		nStartingWidth	:Number;
		
		
		
		public function Scrubber() {
			trace( 'Building Scrubber' );
			
			buttonMode = true;
			nStartingWidth = width;
			aChapterMarkers = new Array();
			
			createBgImages();
			createKnob();
			
			addEventListener( Event.ACTIVATE, onActivate );
			addEventListener( Event.ENTER_FRAME, onEnterFrame );
			addEventListener( MouseEvent.MOUSE_DOWN, onKnobClick );
			addEventListener( MouseEvent.MOUSE_UP, onKnobUnclick );
		}
		
		
		private function createBgImages():void {
			if ( ! spInactive 	) 	spInactive 	= new Sprite();
			//if ( ! spActive 	) 	spActive 	= new Sprite();
			if ( ! bmLeftEdge 	) 	bmLeftEdge 	= new Bitmap( new Scrubber_Bg_Left( 0, 0 ) ); 
			if ( ! bmRightEdge 	) 	bmRightEdge = new Bitmap( new Scrubber_Bg_Right( 0, 0 ) ); 
			
			var mTransform:Matrix = new Matrix( 1, 0, 0, 1, 0, 0 );
			
			spInactive.graphics.clear();
			spInactive.graphics.beginBitmapFill( 
				new Scrubber_Bg_Inactive( 0, 0 ), 
				mTransform, false, true 
			);
			spInactive.graphics.drawRect( 0, 0, nTargetWidth, 9 );
			spInactive.graphics.endFill();
			addChild( spInactive );
			
			/*
			spActive.graphics.clear();
			spActive.graphics.beginBitmapFill( 
				new Scrubber_Bg_Downloaded( 0, 0 ), 
				mTransform, false, true 
			);
			spActive.graphics.drawRect( 0, 0, 5, 9 );
			spActive.graphics.endFill();
			addChild( spActive );
			*/
		}
		
		
		private function createKnob() {
			spKnob = new ScrubKnob();
			spKnob.x = spKnob.y = 4;
			addChild( spKnob );
		}
		
		
		private function refreshDepths() {
			var aDepth:Array = new Array( 
				spInactive//, spActive
			);
			
			for each ( var spMark:ChapterMarker in aChapterMarkers ) {
				aDepth.push( spMark );
			}
			
			aDepth.push( spKnob );
			
			if ( aDepth.length == numChildren ) {
				var i:int = aDepth.length;
				while ( i-- ) {
					if ( getChildIndex( aDepth[i] ) != i ) {
						setChildIndex( aDepth[i], i );
					}
				}
			}
		}
		
		
		public function onResize( nSize:Number = undefined ):void {
			if ( !nSize ) return;
			
			nTargetWidth = nSize;
			nInnerWidth = nSize - 10;
			createBgImages();
			repositionMarkers();
			refreshDepths();
		}
		
		
		public function onKnobClick( event:MouseEvent ) {
			spKnob.startDrag( true, new Rectangle( 0, 4, width - 12, 0 ) );
			refreshDepths();
			bDragging = true;
			
			stage.addEventListener( MouseEvent.MOUSE_UP, onKnobUnclick );
		}
		
		
		public function onKnobUnclick( event:MouseEvent ) {
			var mcContent		:MovieClip 	= WindowManager.spVideoFrame.chCurrent.mcContainer,
				nWorkingWidth	:Number 	= nWorkingWidth * scaleX;
			
			setChapterPosFromX( event.stageX - x );
			
			bDragging = false;
			
			stage.removeEventListener( MouseEvent.MOUSE_UP, onKnobUnclick );
			
			spKnob.stopDrag();
			refreshDepths();
		}
		
		
		private function onActivate( event:Event ) {
			trace( 'Scrubber activated!' );
			
			Streamer.eDispatch.addEventListener( 
				Streamer.EVENT_LOADED_CHAPTERS, onStreamerReady 
			);
			Streamer.eDispatch.addEventListener(
				NewChapterEvent.NEW_CHAPTER, onAddChapter
			);
		}
		
		
		private function onStreamerReady( event:Event ):void {
			trace( 'Streamer ready: nTotal frames =' + Main.plList.sStream.nTotalTime );
		}
		
		
		private function onEnterFrame( event:Event ) {
			if ( !WindowManager.spVideoFrame.chCurrent ) return;
			
			var chCurrent		:Chapter 	= WindowManager.spVideoFrame.chCurrent,
				nWorkingWidth	:Number 	= nTargetWidth * scaleX,
				mcCurrent		:MovieClip 	= chCurrent.mcContainer;
			
			if ( mcCurrent && !bDragging && chCurrent.mMarker ) {
				spKnob.x = mcCurrent.currentFrame / mcCurrent.totalFrames * chCurrent.mMarker.nTargetWidth + chCurrent.mMarker.x;
			}
		}		
		
		
		public function setTotalFrames( nFrames:Number ) {
			nTotalFrames = nFrames;
		}
		
		
		public function onAddChapter( event:NewChapterEvent ) {
			if ( aChapterMarkers.length == 0 ) event.chNew.play();
			
			trace( 'New Chapter Event received! Adding chapter to scrubber.' );
			
			nLoadingFrames += event.chNew.nFrames;
			addChapterMarker( event.chNew );
			
			repositionMarkers();
		}
		
		
		private function addChapterMarker( chNew:Chapter ) {
			trace( 'Adding chapter marker' );
			
			var spChapMark		:ChapterMarker 	= new ChapterMarker( chNew );
			
			chNew.mMarker = spChapMark;
			nLoadingFrames += chNew.nFrames;
			spChapMark.nTargetWidth = chNew.nFrames / nLoadingFrames * nTargetWidth;
			addChild( spChapMark );
			aChapterMarkers.push( spChapMark );
			
			return;
		}
		
		
		private function repositionMarkers() {
			var nCount :Number = 0;
			
			for each( var spMark :ChapterMarker in aChapterMarkers ) {
				spMark.nTargetWidth = spMark.chLink.nFrames / nLoadingFrames * nTargetWidth * 2;
				spMark.resizeProgressBar();
				
				if ( nCount != 0 ) {
					var chPrev :ChapterMarker = aChapterMarkers[ nCount - 1 ];
					spMark.x = chPrev.x + chPrev.nTargetWidth;
				}
				
				nCount++;
			}
		}
		
		
		public function getChapterFromX( nX :Number = 0 ) :Chapter {
			trace( 'searching for chapter at position ' + nX );
			
			if ( !nX ) return aChapterMarkers[ 0 ].chLink;
			
			for ( var i = 0; i < aChapterMarkers.length; i++ ) {
				var chMark :ChapterMarker = aChapterMarkers[ i ];
				
				if ( nX > chMark.x + chMark.width ) {
					continue; 
				} else {
					return aChapterMarkers[ i ].chLink;
				}
			}
			
			return aChapterMarkers[ aChapterMarkers.length ].chLink;
		}
		
		
		public function setChapterPosFromX( nX:Number ) {
			var chTarget :Chapter = getChapterFromX( nX );
			chTarget.activate();
			chTarget.seek( ( nX - chTarget.mMarker.x ) / chTarget.mMarker.nTargetWidth );
		}
	}
	
}