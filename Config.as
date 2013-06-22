package{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	
	/**
	 * @author Brett Richardson
	 */
	
	dynamic class Config {
		
		public static var 
		xmlURL		:String,
		singleURL	:String;
		
		
		public static function loadVars( dispObj:DisplayObject ) {
			var aDefaults = Config.getDefaults();
			var oParams = LoaderInfo( dispObj.root.loaderInfo ).parameters;
			
			for ( var key:String in aDefaults ) {
				Config[ key ] = aDefaults[ key ];
			}
			for ( key in oParams ) {
				Config[ key ] = oParams[ key ];
			}
		}
		
		
		public static function getDefaults():Array {
			var aDefaults = new Array();
			
			aDefaults['xmlURL'] = 'http://localhost/budgetmovies/playlist_test.xml'; //'http://dev.sparksinteractive.co.nz/clients/sorted/sortedin60/playlist.xml';//'http://s4demo.sparksinteractive.co.nz/ad-landing/mediaplayer/BudgetCalc_Playlist.xml?q=' + new Date().getTime();
			aDefaults['singleURL'] = ''; //'http://s4demo.sparksinteractive.co.nz/ad-landing/mediaplayer/budget_part1.swf';
			
			return aDefaults;
		}
	}
	
}