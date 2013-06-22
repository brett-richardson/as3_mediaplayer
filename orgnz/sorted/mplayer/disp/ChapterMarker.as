package orgnz.sorted.mplayer.disp {
	import fl.motion.Tweenables;
	import fl.transitions.easing.Strong;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import orgnz.sorted.mplayer.Chapter;
	import flash.geom.Matrix;
	import flash.events.MouseEvent;
	import orgnz.sorted.mplayer.WindowManager;
	
	/**
	 * @author Brett Richardson
	 */
	
	public class ChapterMarker extends Sprite {
		
		public var
		chLink			:Chapter,
		spActive		:Sprite,
		spPopup			:ChapterTitle,
		nTargetWidth	:Number,
		twFade			:Tween,
		twYSlide		:Tween;
		
		
		
		public function ChapterMarker( chLink:Chapter ) {
			this.chLink = chLink;
			chLink.uLoader.contentLoaderInfo.addEventListener( Event.INIT, onBeginLoad );
			chLink.uLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onComplete );
			chLink.uLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgress );
			
			addEventListener( MouseEvent.MOUSE_OVER, onRollOver, false, 0, true );
		}
		
		
		public function resizeProgressBar() {
			if ( !spActive ) return;
			
			spActive.width = nTargetWidth * chLink.nLoadPerc;
		}
		
		
		private function onRollOver( event:MouseEvent ) {
			stage.addEventListener( MouseEvent.CLICK, onRollOut );
			addEventListener( MouseEvent.ROLL_OUT, onRollOut );
			
			if ( !spPopup || !stage.contains( spPopup ) ) {
				spPopup = new ChapterTitle( chLink.sTitle, x + 38, event.stageY );
				spPopup.alpha = 0;
				spPopup.y = spPopup.nTargetY - 10;
				stage.addChild( spPopup );
			} else {
				twFade.stop();
				twYSlide.stop();
			}
			
			twFade = new Tween( spPopup, 'alpha', Strong.easeOut, spPopup.alpha, 1, 24 );
			twYSlide = new Tween( spPopup, 'y', Strong.easeOut, spPopup.y, spPopup.nTargetY, 24 );
			
			twFade.removeEventListener( "motionFinish", onFadeOutFinish );
		}
		
		
		private function onRollOut( event:MouseEvent ) {
			trace( 'Roll out chapter marker!' );
			
			stage.removeEventListener( MouseEvent.CLICK, onRollOut );
			
			twFade = new Tween( spPopup, 'alpha', Strong.easeOut, spPopup.alpha, 0, 12 );
			twYSlide = new Tween( spPopup, 'y', Strong.easeOut, spPopup.y, spPopup.nTargetY - 10, 12 );
			
			twFade.addEventListener( "motionFinish", onFadeOutFinish );
		}
		
		
		private function onFadeOutFinish( event:Event ) {
			twFade.removeEventListener( "motionFinish", onFadeOutFinish );
			if ( !stage.contains( spPopup ) ) return;
			
			stage.removeChild( spPopup );
		}
		
		
		private function onBeginLoad( event:Event ) {
			if ( ! spActive ) spActive 	= new Sprite();
			
			var mTransform:Matrix = new Matrix( 1, 0, 0, 1, 0, 0 );
			spActive.graphics.clear();
			spActive.graphics.beginBitmapFill( 
				new Scrubber_Bg_Downloaded( 0, 0 ), 
				mTransform, false, true 
			);
			spActive.graphics.drawRect( 0, 0, 5, 9 );
			spActive.graphics.endFill();
			addChild( spActive );
		}
		
		
		private function onProgress( event:ProgressEvent ) {
			if ( !spActive ) return;
			
			spActive.width = nTargetWidth * chLink.nLoadPerc;
		}
		
		
		private function onComplete( event:Event ) {
			spActive.width = nTargetWidth;
		}
		
		
		private function setAsActive( nPos:Number = undefined ) {
			WindowManager.spVideoFrame.showChapter( chLink, true, nPos );
		}
	}
	
}