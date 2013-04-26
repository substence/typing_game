package com.nicotroia.typinggame
{
	import com.nicotroia.typinggame.controller.commands.GotoPageCommand;
	import com.nicotroia.typinggame.controller.commands.LayoutAppCommand;
	import com.nicotroia.typinggame.controller.commands.LoadSettingsCommand;
	import com.nicotroia.typinggame.controller.commands.SaveSettingsCommand;
	import com.nicotroia.typinggame.controller.commands.StartupAnimationCommand;
	import com.nicotroia.typinggame.controller.events.LayoutEvent;
	import com.nicotroia.typinggame.controller.events.NavigationEvent;
	import com.nicotroia.typinggame.model.LayoutModel;
	import com.nicotroia.typinggame.model.SequenceModel;
	import com.nicotroia.typinggame.model.SettingsModel;
	import com.nicotroia.typinggame.view.buttons.ButtonBase;
	import com.nicotroia.typinggame.view.buttons.ButtonBaseMediator;
	import com.nicotroia.typinggame.view.pages.PageBase;
	import com.nicotroia.typinggame.view.pages.PageBaseMediator;
	import com.nicotroia.typinggame.view.pages.SettingsPage;
	import com.nicotroia.typinggame.view.pages.SettingsPageMediator;
	import com.nicotroia.typinggame.view.pages.WelcomePage;
	import com.nicotroia.typinggame.view.pages.WelcomePageMediator;
	
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.StageOrientationEvent;
	import flash.geom.Rectangle;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.StarlingContext;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.utils.RectangleUtil;

	public class GameContext extends StarlingContext
	{
		public var pageContainer:Sprite;
		public var overlayContainer:Sprite;
		//public var shadowBox:ShadowBoxView;
		//public var loadingSpinner:TransparentSpinner;
		//public var loadingSpinnerVector:TransparentSpinnerVector;
		
		private var _init:Boolean;
		
		public function GameContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			//models
			injector.mapSingleton(SequenceModel);
			injector.mapSingleton(LayoutModel);
			injector.mapSingleton(SettingsModel);
			injector.mapValue(DisplayObjectContainer, contextView, "contextView");
			
			
			//graphics
			injector.mapValue(Stage, Starling.current.nativeStage);
			
			pageContainer = new Sprite();
			injector.mapValue(Sprite, pageContainer, "pageContainer");
			
			overlayContainer = new Sprite();
			injector.mapValue(Sprite, overlayContainer, "overlayContainer");
			
			
			//startup chain
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, LoadSettingsCommand, ContextEvent);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupAnimationCommand, ContextEvent);
			
			//events
			commandMap.mapEvent(LayoutEvent.RESIZE, LayoutAppCommand, LayoutEvent);
			commandMap.mapEvent(LayoutEvent.ORIENTATION_CHANGE, LayoutAppCommand, LayoutEvent);
			commandMap.mapEvent(NavigationEvent.NAVIGATE_TO_PAGE, GotoPageCommand, NavigationEvent);
			commandMap.mapEvent(NavigationEvent.SETTINGS_PAGE_CONFIRMED, SaveSettingsCommand, NavigationEvent);
			//commandMap.mapEvent(LoadingEvent.PAGE_LOADING, ShowLoadingSpinnerCommand, LoadingEvent);
			//commandMap.mapEvent(LoadingEvent.LOADING_FINISHED, HideLoadingSpinnerCommand, LoadingEvent);
			//commandMap.mapEvent(NotificationEvent.ADD_TEXT_TO_LOADING_SPINNER, AddTextToLoadingSpinnerCommand, NotificationEvent);
			
			
			//pages
			//If you'd like mediators to be created automatically, 
			//but not to be removed when the view leaves the stage, 
			//set autoRemove to false, but be sure to remove the mediator when you no longer need it.
			mediatorMap.mapView(PageBase, PageBaseMediator, null, true, false);
			mediatorMap.mapView(WelcomePage, WelcomePageMediator, [PageBase, WelcomePage], true, false);
			mediatorMap.mapView(SettingsPage, SettingsPageMediator, [PageBase, SettingsPage], true, false);
			
			
			//buttons
			mediatorMap.mapView(ButtonBase, ButtonBaseMediator);
			//mediatorMap.mapView(ShadowBoxView, ShadowBoxMediator);
			//mediatorMap.mapView(TransparentSpinner, TransparentSpinnerMediator);
			
			
			//other
			contextView.stage.addEventListener(Event.RESIZE, appResizeHandler);
			Starling.current.nativeStage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler);
			
			
			//finally
			//super.startup();
			
			
			//hmm
			appResizeHandler(new ResizeEvent(ResizeEvent.RESIZE, Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight)); 
		}
		
		protected function appResizeHandler(event:ResizeEvent = null):void
		{
			trace("RESIZE. " + event.width, event.height); 
			
			contextView.stage.stageWidth = event.width;
			contextView.stage.stageHeight = event.height;
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, event.width, event.height), 
				new Rectangle(0, 0, Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight), 
				"showAll");
			
			Starling.current.viewPort = viewPort;
			
			if( ! _init ) { 
				_init = true;
				
				//finally
				super.startup();
				
				eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.RESIZE));
			}
		}
		
		protected function orientationChangeHandler(event:StageOrientationEvent):void
		{
			trace("ORIENTATION CHANGE. " + event.beforeOrientation + " to " + event.afterOrientation);
			
			eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.ORIENTATION_CHANGE)); 
		}
	}
}