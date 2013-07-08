package com.tengu.fsm.api
{
	public interface IState
	{
		function set manager (value:IFSM):void;
		
		function onEnter ():void;
		function onExit ():void;
	}
}