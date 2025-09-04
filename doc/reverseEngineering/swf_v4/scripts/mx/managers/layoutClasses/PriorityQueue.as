package mx.managers.layoutClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   import mx.core.IChildList;
   import mx.core.IRawChildrenContainer;
   import mx.core.mx_internal;
   import mx.managers.ILayoutManagerClient;
   
   use namespace mx_internal;
   
   public class PriorityQueue
   {
      
      mx_internal static const VERSION:String = "4.0.0.14159";
      
      private var arrayOfDictionaries:Array = [];
      
      private var minPriority:int = 0;
      
      private var maxPriority:int = -1;
      
      public var generation:int = 0;
      
      public function PriorityQueue()
      {
         super();
      }
      
      public function addObject(param1:Object, param2:int) : void
      {
         if(!this.arrayOfDictionaries[param2])
         {
            this.arrayOfDictionaries[param2] = new Object();
            this.arrayOfDictionaries[param2].length = 0;
            this.arrayOfDictionaries[param2].items = new Dictionary(false);
         }
         if(this.arrayOfDictionaries[param2].items[param1] == null)
         {
            this.arrayOfDictionaries[param2].items[param1] = true;
            ++this.arrayOfDictionaries[param2].length;
         }
         if(this.maxPriority < this.minPriority)
         {
            this.minPriority = this.maxPriority = param2;
         }
         else
         {
            if(param2 < this.minPriority)
            {
               this.minPriority = param2;
            }
            if(param2 > this.maxPriority)
            {
               this.maxPriority = param2;
            }
         }
         ++this.generation;
      }
      
      public function removeLargest() : Object
      {
         var _loc2_:Object = null;
         var _loc1_:Object = null;
         if(this.minPriority <= this.maxPriority)
         {
            while(!this.arrayOfDictionaries[this.maxPriority] || this.arrayOfDictionaries[this.maxPriority].length == 0)
            {
               --this.maxPriority;
               if(this.maxPriority < this.minPriority)
               {
                  return null;
               }
            }
            var _loc3_:int = 0;
            var _loc4_:* = this.arrayOfDictionaries[this.maxPriority].items;
            for(_loc2_ in _loc4_)
            {
               _loc1_ = _loc2_;
               this.removeChild(ILayoutManagerClient(_loc2_),this.maxPriority);
            }
            while(!this.arrayOfDictionaries[this.maxPriority] || this.arrayOfDictionaries[this.maxPriority].length == 0)
            {
               --this.maxPriority;
               if(this.maxPriority < this.minPriority)
               {
                  break;
               }
            }
         }
         return _loc1_;
      }
      
      public function removeLargestChild(param1:ILayoutManagerClient) : Object
      {
         var _loc4_:Object = null;
         var _loc2_:int = this.maxPriority;
         var _loc3_:int = param1.nestLevel;
         while(_loc3_ <= _loc2_)
         {
            if(Boolean(this.arrayOfDictionaries[_loc2_]) && this.arrayOfDictionaries[_loc2_].length > 0)
            {
               if(_loc2_ == param1.nestLevel)
               {
                  if(this.arrayOfDictionaries[_loc2_].items[param1])
                  {
                     this.removeChild(ILayoutManagerClient(param1),_loc2_);
                     return param1;
                  }
               }
               else
               {
                  for(_loc4_ in this.arrayOfDictionaries[_loc2_].items)
                  {
                     if(_loc4_ is DisplayObject && this.contains(DisplayObject(param1),DisplayObject(_loc4_)))
                     {
                        this.removeChild(ILayoutManagerClient(_loc4_),_loc2_);
                        return _loc4_;
                     }
                  }
               }
               _loc2_--;
            }
            else
            {
               if(_loc2_ == this.maxPriority)
               {
                  --this.maxPriority;
               }
               _loc2_--;
               if(_loc2_ < _loc3_)
               {
                  break;
               }
            }
         }
         return null;
      }
      
      public function removeSmallest() : Object
      {
         var _loc2_:Object = null;
         var _loc1_:Object = null;
         if(this.minPriority <= this.maxPriority)
         {
            while(!this.arrayOfDictionaries[this.minPriority] || this.arrayOfDictionaries[this.minPriority].length == 0)
            {
               ++this.minPriority;
               if(this.minPriority > this.maxPriority)
               {
                  return null;
               }
            }
            var _loc3_:int = 0;
            var _loc4_:* = this.arrayOfDictionaries[this.minPriority].items;
            for(_loc2_ in _loc4_)
            {
               _loc1_ = _loc2_;
               this.removeChild(ILayoutManagerClient(_loc2_),this.minPriority);
            }
            while(!this.arrayOfDictionaries[this.minPriority] || this.arrayOfDictionaries[this.minPriority].length == 0)
            {
               ++this.minPriority;
               if(this.minPriority > this.maxPriority)
               {
                  break;
               }
            }
         }
         return _loc1_;
      }
      
      public function removeSmallestChild(param1:ILayoutManagerClient) : Object
      {
         var _loc3_:Object = null;
         var _loc2_:int = param1.nestLevel;
         while(_loc2_ <= this.maxPriority)
         {
            if(Boolean(this.arrayOfDictionaries[_loc2_]) && this.arrayOfDictionaries[_loc2_].length > 0)
            {
               if(_loc2_ == param1.nestLevel)
               {
                  if(this.arrayOfDictionaries[_loc2_].items[param1])
                  {
                     this.removeChild(ILayoutManagerClient(param1),_loc2_);
                     return param1;
                  }
               }
               else
               {
                  for(_loc3_ in this.arrayOfDictionaries[_loc2_].items)
                  {
                     if(_loc3_ is DisplayObject && this.contains(DisplayObject(param1),DisplayObject(_loc3_)))
                     {
                        this.removeChild(ILayoutManagerClient(_loc3_),_loc2_);
                        return _loc3_;
                     }
                  }
               }
               _loc2_++;
            }
            else
            {
               if(_loc2_ == this.minPriority)
               {
                  ++this.minPriority;
               }
               _loc2_++;
               if(_loc2_ > this.maxPriority)
               {
                  break;
               }
            }
         }
         return null;
      }
      
      public function removeChild(param1:ILayoutManagerClient, param2:int = -1) : Object
      {
         var _loc3_:int = param2 >= 0 ? param2 : param1.nestLevel;
         if(Boolean(this.arrayOfDictionaries[_loc3_]) && this.arrayOfDictionaries[_loc3_].items[param1] != null)
         {
            delete this.arrayOfDictionaries[_loc3_].items[param1];
            --this.arrayOfDictionaries[_loc3_].length;
            ++this.generation;
            return param1;
         }
         return null;
      }
      
      public function removeAll() : void
      {
         this.arrayOfDictionaries.splice(0);
         this.minPriority = 0;
         this.maxPriority = -1;
         this.generation += 1;
      }
      
      public function isEmpty() : Boolean
      {
         return this.minPriority > this.maxPriority;
      }
      
      private function contains(param1:DisplayObject, param2:DisplayObject) : Boolean
      {
         var _loc3_:IChildList = null;
         if(param1 is IRawChildrenContainer)
         {
            _loc3_ = IRawChildrenContainer(param1).rawChildren;
            return _loc3_.contains(param2);
         }
         if(param1 is DisplayObjectContainer)
         {
            return DisplayObjectContainer(param1).contains(param2);
         }
         return param1 == param2;
      }
   }
}

