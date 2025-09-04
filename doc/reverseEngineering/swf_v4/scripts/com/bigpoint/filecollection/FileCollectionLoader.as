package com.bigpoint.filecollection
{
   import com.bigpoint.filecollection.vo.FileVO;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class FileCollectionLoader extends URLLoader
   {
      
      private var fileVO:FileVO;
      
      private var useHash:Boolean = false;
      
      public function FileCollectionLoader(param1:FileVO, param2:Boolean = false)
      {
         this.useHash = param2;
         this.fileVO = param1;
         super(null);
      }
      
      public function loadFile() : void
      {
         var _loc1_:URLRequest = new URLRequest(this.fileVO.getFileName(this.useHash));
         if(FileCollection.logging)
         {
         }
         load(_loc1_);
      }
      
      public function getFileVO() : FileVO
      {
         return this.fileVO;
      }
   }
}

