package com.nicotroia.typinggame.controller.commands
{
	import com.nicotroia.typinggame.model.SettingsModel;
	import com.nicotroia.whatcoloristhis.Settings;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.StarlingCommand;

	public class LoadSettingsCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject]
		public var settingsModel:SettingsModel;
		
		override public function execute():void
		{
			trace("LoadSettingsCommand via " + event.type);
			
			var array:Array = settingsModel.readSettings();
			
			if( array != null ) { 
				//Settings.fetchCrayolaResults = array[0];
			}
		}
	}
}