package com.nicotroia.typinggame.view.pages
{
	import com.nicotroia.typinggame.controller.events.NavigationEvent;
	import com.nicotroia.typinggame.model.SequenceModel;
	
	import starling.display.Button;
	import starling.events.Event;

	public class SettingsPageMediator extends PageBaseMediator
	{
		[Inject]
		public var settingsPage:SettingsPage;
		
		override protected function pageAddedToStageHandler(event:Event = null):void
		{
			super.pageAddedToStageHandler(event);
			
			//trace("settings page addedToStage");
			
			eventMap.mapStarlingListener(settingsPage, Event.TRIGGERED, settingsPageTriggeredHandler);
		}
		
		private function settingsPageTriggeredHandler(event:Event):void
		{
			var buttonTriggered:Button = event.target as Button;
			
			trace("welcome page button triggered: " + buttonTriggered);
			
			if( buttonTriggered == settingsPage.cancelButton ) 
			{ 
				eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_RIGHT));
			}
			
			if( buttonTriggered == settingsPage.acceptButton )
			{
				//will trigger SaveSettingsCommand
				eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.SETTINGS_PAGE_CONFIRMED ));
				
				eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_RIGHT));
			}
		}
		
		override public function onRemove():void
		{
			eventMap.unmapStarlingListener(settingsPage, Event.TRIGGERED, settingsPageTriggeredHandler);
			
			super.onRemove();
			
		}
	}
}