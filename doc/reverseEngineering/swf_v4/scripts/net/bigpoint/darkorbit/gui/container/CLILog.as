package net.bigpoint.darkorbit.gui.container
{
   import fl.controls.TextArea;
   import fl.controls.TextInput;
   import flash.errors.EOFError;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.StringUtil;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.ICommandLogTarget;
   import net.bigpoint.darkorbit.Main;
   
   public class CLILog extends SimpleContainer implements ICommandLogTarget
   {
      
      private static const logger:ILogger = Log.getLogger("CLILog");
      
      private var _main:Main;
      
      private var _outputField:TextArea;
      
      private var _inputField:TextInput;
      
      private var _firstCommand:LineCommand;
      
      private var _lastCommand:LineCommand;
      
      private var _currentCommand:LineCommand;
      
      private var _logSessionCookie:SharedObject;
      
      private var _cookieName:String;
      
      private var cmdWhiteList:Dictionary = new Dictionary();
      
      public function CLILog(param1:Main)
      {
         super(param1.getGuiManager(),SimpleContainer.CLASS_COMMAND_LINE_INTERFACE);
         this._main = param1;
         this._outputField = new TextArea();
         addChild(this._outputField);
         this._inputField = new TextInput();
         addChild(this._inputField);
         this._cookieName = "doclilog" + Hero.userID;
      }
      
      public function initSessionCookie() : void
      {
         this._logSessionCookie = SharedObject.getLocal(this._cookieName);
         if(this._logSessionCookie.size != 0)
         {
            if(this._logSessionCookie.data.commands != undefined)
            {
               this.initCommandHistory(ByteArray(this._logSessionCookie.data.commands));
            }
         }
         else
         {
            this.initCommandHistory();
         }
      }
      
      private function initCommandHistory(param1:ByteArray = null) : void
      {
         var commandRaw:String = null;
         var byteCommands:ByteArray = param1;
         this._firstCommand = null;
         this._firstCommand = new LineCommand();
         this._lastCommand = null;
         this._lastCommand = new LineCommand();
         this._firstCommand.next = this._lastCommand;
         this._lastCommand.previous = this._firstCommand;
         this._currentCommand = this._lastCommand;
         if(byteCommands != null)
         {
            while(byteCommands.bytesAvailable)
            {
               commandRaw = "";
               try
               {
                  commandRaw = byteCommands.readUTF();
                  if(commandRaw != "\n")
                  {
                     this.addCommand(commandRaw,false);
                  }
               }
               catch(e:EOFError)
               {
                  writeOutput("EOFError " + e.message);
               }
            }
         }
      }
      
      public function setOutputField(param1:TextArea) : void
      {
         if(this._outputField != null && contains(this._outputField))
         {
            removeChild(this._outputField);
         }
         this._outputField = param1;
         this._outputField.editable = false;
         this._outputField.textField.selectable = true;
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.color = 8947848;
         _loc2_.size = 12;
         _loc2_.font = "Courier New";
         this._outputField.setStyle("textFormat",_loc2_);
         addChild(this._outputField);
      }
      
      public function setInputField(param1:TextInput) : void
      {
         if(this._inputField != null && contains(this._inputField))
         {
            removeChild(this._inputField);
         }
         this._inputField = param1;
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.color = 1118481;
         _loc2_.size = 12;
         _loc2_.font = "Courier New";
         _loc2_.bold = true;
         this._inputField.setStyle("textFormat",_loc2_);
         this._inputField.addEventListener(Event.CHANGE,this.handleTextChange);
         this._inputField.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         this._inputField.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
         addChild(this._inputField);
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:int = int(param1.keyCode);
         switch(_loc2_)
         {
            case Keyboard.DOWN:
               this.loopDown();
               break;
            case Keyboard.UP:
               this.loopUp();
               break;
            case Keyboard.ENTER:
               this.parseInput(this._inputField.text);
               this._inputField.text = "";
         }
      }
      
      private function handleKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:int = int(param1.keyCode);
         switch(_loc2_)
         {
            case Keyboard.DOWN:
            case Keyboard.UP:
               this._inputField.setSelection(this._inputField.text.length,this._inputField.text.length);
         }
      }
      
      private function loopUp() : void
      {
         if(this._currentCommand == this._lastCommand)
         {
            this._currentCommand.value = this._inputField.text;
         }
         if(this._currentCommand.previous != null)
         {
            this._currentCommand = this._currentCommand.previous;
         }
         this._inputField.text = this._currentCommand.value;
      }
      
      private function loopDown() : void
      {
         if(this._currentCommand.next != null)
         {
            this._currentCommand = this._currentCommand.next;
         }
         this._inputField.text = this._currentCommand.value;
      }
      
      private function parseInput(param1:String) : void
      {
         param1 = StringUtil.trim(param1);
         if(param1.length == 0)
         {
            return;
         }
         if(param1.charAt(0) == "+")
         {
            param1 = param1.substring(1,param1.length);
            this.addToCmdWhiteList(param1.split(","));
         }
         else if(param1.charAt(0) == "-")
         {
            param1 = param1.substring(1,param1.length);
            this.removeFromCmdWhiteList(param1.split(","));
         }
         else if(param1.charAt(0) == ":")
         {
            param1 = param1.substring(1,param1.length);
            switch(param1)
            {
               case "reset":
               case "clear":
                  this.clearHistory();
            }
         }
         else
         {
            this._main.getConnectionManager().sendCommand(param1);
            this.writeOutput(param1);
            if(this._currentCommand.previous.value == param1)
            {
               logger.fatal("list stays untouched " + param1);
            }
            else if(this._lastCommand.value == this._lastCommand.previous.value)
            {
               this._lastCommand.value = "";
            }
            else
            {
               this.addCommand(param1);
            }
         }
      }
      
      private function addCommand(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:LineCommand = new LineCommand();
         _loc3_.value = param1;
         _loc3_.next = this._lastCommand;
         this._lastCommand.previous.next = _loc3_;
         _loc3_.previous = this._lastCommand.previous;
         this._lastCommand.previous = _loc3_;
         this._currentCommand = this._lastCommand;
         if(param2)
         {
            this.saveCommands();
         }
      }
      
      private function removeFromCmdWhiteList(param1:Array) : void
      {
      }
      
      private function addToCmdWhiteList(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            this.cmdWhiteList[_loc2_] = true;
         }
      }
      
      public function setSize(param1:int, param2:int) : void
      {
         this._outputField.width = param1;
         this._outputField.height = param2 - 20;
         this._inputField.width = param1;
         this._inputField.height = 20;
         this._inputField.y = param2 - 20;
      }
      
      public function writeOutput(param1:String) : void
      {
         this._outputField.text += param1 + "\n";
         this._outputField.verticalScrollPosition = this._outputField.maxVerticalScrollPosition;
      }
      
      public function initOutput(param1:String) : void
      {
      }
      
      private function handleTextChange(param1:Event) : void
      {
         this._currentCommand = this._lastCommand;
         this._currentCommand.value = this._inputField.text;
      }
      
      private function saveCommands() : void
      {
         var flushStatus:String = null;
         var commandBytes:ByteArray = new ByteArray();
         var commandToStore:LineCommand = this._firstCommand;
         while(commandToStore.next != null)
         {
            if(commandToStore.value != "")
            {
               commandBytes.writeUTF(commandToStore.value);
               commandBytes.writeUTF("\n");
            }
            commandToStore = commandToStore.next;
         }
         this._logSessionCookie.data.commands = commandBytes;
         try
         {
            flushStatus = this._logSessionCookie.flush(10000);
         }
         catch(error:Error)
         {
            writeOutput("Error...Could not write SharedObject to disk");
         }
         if(flushStatus != null)
         {
            switch(flushStatus)
            {
               case SharedObjectFlushStatus.PENDING:
                  this.writeOutput("Requesting permission to save cookie...\n");
                  this._logSessionCookie.addEventListener(NetStatusEvent.NET_STATUS,this.onFlushStatus);
                  break;
               case SharedObjectFlushStatus.FLUSHED:
            }
         }
      }
      
      private function clearHistory() : void
      {
         this._logSessionCookie.clear();
         this.writeOutput("History cleared");
         this.initCommandHistory();
      }
      
      private function onFlushStatus(param1:NetStatusEvent) : void
      {
         this.writeOutput("User closed permission dialog...\n");
         switch(param1.info.code)
         {
            case "SharedObject.Flush.Success":
               this.writeOutput("User granted permission -- cookie saved.\n");
               break;
            case "SharedObject.Flush.Failed":
               this.writeOutput("User denied permission -- cookie not saved.\n");
         }
         this._logSessionCookie.removeEventListener(NetStatusEvent.NET_STATUS,this.onFlushStatus);
      }
      
      public function passFullInCommand(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         for(_loc3_ in this.cmdWhiteList)
         {
            _loc2_ = int(this.cmdWhiteList[_loc3_]);
            if(param1.substring(0,_loc2_) == "0|" + _loc3_)
            {
               this.writeOutput(param1.substring(2,param1.length));
            }
         }
      }
   }
}

