package com.nicotroia.typinggame.controller.commands
{
	import com.nicotroia.typinggame.model.SettingsModel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	public class SaveSettingsCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject]
		public var settingsModel:SettingsModel;
		
		override public function execute():void
		{
			trace("SaveSettingsCommand via " + event.type);
			
			settingsModel.writeSettings();
		}
	}
}