# Pascal-Lazarus-Projet_SGBD
```
Projet pour lier la base de donnée et le front-end

Base de donnée : Bien immobilier
Le but est de montrer tous les biens en utilisant Pascal et SQL
```

Problème rencontré  avec une procédure qui modifie un bouton

Si problème avec 
//unit1.pas(60,5) Error: Identifier not found "Edit1"
//unit1.pas(61,5) Error: Identifier not found "Edit2"

Il faut préciser le TForm dans la procedure
Edit1 and Edit2 exist within the context of the class TForm1. Several instances of this class can exist. Therefore you must always specify the instance to which Edit1 and Edit2 belong. Since your class is probably instantiated as Form1 you must mention Form1.Edit1 and Form1.Edit2.

But this is not the recommended way because now your procedure "CreateFile" will only work if your form is named as "Form1". It is much better to make CreateFile a "method" of the class TForm1, i.e. you declare it within TForm1. The form itself "knows" that Edit1 and Edit2 belong to it, and therefore there is not need to specify the form name here. In addition, you should also declare tfOut as a variable of the class because you probably won't need it from outside the form:

Au lieu de 
unit Unit1;
 
{$mode objfpc}{$H+}
 
interface
 
uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;
 
type
 
    { TForm1 }
 
    TForm1 = class(TForm)
        Button1: TButton;
        Button2: TButton;
        Edit1: TEdit;
        Edit2: TEdit;
        Label1: TLabel;
        Label2: TLabel;
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
 
 
    private
 
    public
 
    end;
 Const
     C_FNAME = 'textfile.txt';
 
var
    Form1: TForm1;
    tfOut: TextFile;
implementation
 
{$R *.lfm}
 
Procedure CreateFile;
Begin
  // Set the name of the file that will be created
  AssignFile(tfOut, C_FNAME);
 
  {$I+}
 
 
 try
    // Create the file, write some text and close it.
    rewrite(tfOut);
    writeln(tfOut, 'Line 1');
    writeln(tfOut, 'Line 2');
    CloseFile(tfOut);
 
  except
    // If there was an error the reason can be found here
    on E: EInOutError do
         showmessage('Error opening file = '+inttostr(ioresult));
    end;
    Edit1.Text := C_Fname;
    Edit2.text :=  inttostr(ioresult)
   end;
 
 
 
//end;
 
{ TForm1 }
 
 
procedure TForm1.Button1Click(Sender: TObject);
begin
      CreateFile;
end;
 
procedure TForm1.Button2Click(Sender: TObject);
begin
    Close;
end;
 
end.

-----
Faire
type
  TForm1 = class(TForm)
  ,,,
  private  
    tfOut: TextFile;  // or put these in the "public" section if you call these from somwhere outside TForm1
    procedure CreateFile;  
   ....
  end;
 
procedure TForm1.CreateFile;
Begin
  // Set the name of the file that will be created
  AssignFile(tfOut, C_FNAME);
  ....
  Edit1.Text := C_Fname;
  Edit2.Text := IntToStr(IOResult);
end;
