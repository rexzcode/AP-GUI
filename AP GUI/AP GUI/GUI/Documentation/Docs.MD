# Documentation Formatting

***

Each argument is listed with its name followed by its type in angle brackets (`<>`), indicating the kind of data it expects.

**Example:**

```lua
Title <string>
```

**Use case example:**

```lua
Title = "Kuzu Hub"
```

***

A `...` before a `<table>` type means the function can take multiple arguments in a variable-length table.

**Example:**

```lua
Tree <...table: FruitName, FruitColor> -- Accepts multiple Fruit definitions, each as a table with a Name and Color.
```

**Use case example:**

```lua
Tree = {
    {
        FruitName = "Apple"
        FruitColor = Color3.fromRGB(255,0,0)
    },
    {
        FruitName = "Orange"
        FruitColor = Color3.fromRGB(255,165,0)
    }
}
```

***

A colon (`:`) inside a type means those are the arguments that the type expects.

**Example:**

```lua
PrintWhat <string: "Hello, World!", "Goodbye, world."> -- Expects one of the two strings.
```

**Use case example:**

```lua
PrintWhat = "Hello, World!" -- Is expected (Accepted)
--
PrintWhat = "Goodbye, world." -- Is expected (Accepted)
--
PrintWhat = "Lorem Ipsum" -- Not expected (Rejected)
```

***

A `():` after a function type indicates the return type.

**Example:**

```lua
Callback <function(): string> -- The function returns a string when called.
```

**Use case example:**

```lua
Callback = function(Input)
    print(Input)
end)
```

***

A `(): void` after a function type indicates it does not return anything.

**Example:**

```lua
Callback <function(): void> -- The function returns nothing when called.
```

**Use case example:**

```lua
Callback = function()
    print("Hello, World!")
end)
```

***

`<type or type>` means the argument can accept either type.

**Example:**

```lua
Default <number or table> -- Accepts either a number or a table as the default value.
```

**Use case example:**

```lua
Default = 5 -- Accepted
--
Default = {"Hello", "World"} -- Accepted
--
Default = true -- Rejected (not a number or table)
```

***

A `:` followed by a type indicates a return value and its type.

**Example:**

```lua
:GetFruitSize(<string>: number) -- Returns the size of the specified fruit.
:GetState(: boolean) -- Returns whether the window is currently visible or not.
```

**Use case example:**

```lua
:GetFruitSize("Apple") -- Returns the size as a number of an apple
--
:GetState() -- Returns the state as a boolean
```

***


# Loading Maclib

First, you must import and define the Maclib module, place this code somewhere to begin.

```lua
local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()
```

Functions

<pre class="language-lua"><code class="lang-lua">:Demo() -- Brings up a demo window

:SetFolder(&#x3C;string> Folder) -- Sets the folder all configs are saved in.
:SaveConfig(&#x3C;string> Path) -- Saves all element values to a file in the folder you set with :SetFolder(), you can ignore certain elements by setting their .IgnoreConfig to true, or simply not defining a flag.
:LoadConfig(&#x3C;string> Path) -- Loads a config located at path.
:RefreshConfigList(: table) -- Returns a table of all saved config names ( eg. {"Legit.json", "Rage.json"} )
<strong>:LoadAutoLoadConfig() -- Loads the config the user selected to automatically load.
</strong><strong>--// To insert a pre-made config section, reference the "Adding tabs" page.
</strong></code></pre>



# Loading Maclib

First, you must import and define the Maclib module, place this code somewhere to begin.

```lua
local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()
```

Functions

<pre class="language-lua"><code class="lang-lua">:Demo() -- Brings up a demo window

:SetFolder(&#x3C;string> Folder) -- Sets the folder all configs are saved in.
:SaveConfig(&#x3C;string> Path) -- Saves all element values to a file in the folder you set with :SetFolder(), you can ignore certain elements by setting their .IgnoreConfig to true, or simply not defining a flag.
:LoadConfig(&#x3C;string> Path) -- Loads a config located at path.
:RefreshConfigList(: table) -- Returns a table of all saved config names ( eg. {"Legit.json", "Rage.json"} )
<strong>:LoadAutoLoadConfig() -- Loads the config the user selected to automatically load.
</strong><strong>--// To insert a pre-made config section, reference the "Adding tabs" page.
</strong></code></pre>



# Adding a Global Setting

Global Settings simplifies your experience by integrating Boolean-based settings management directly into the main interface, partially eliminating the need for additional tabs.\
![](https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2F5IUSwRLqwA5kuwC798u6%2Fimage.png?alt=media\&token=4b3161eb-07e4-4b80-a934-9a5f6ee90717)

{% hint style="info" %}
You can access the global settings menu by pressing the "Globe" Icon beside the title bar.<img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FgtysEAEPOGLkjq7aADnA%2Fimage.png?alt=media&#x26;token=96b9f1c9-5e4c-4e39-a57d-c71ccf4802b7" alt="" data-size="original">
{% endhint %}

```lua
local Global_Setting = Window:GlobalSetting({
  Name <string>
  Default <boolean>
  Callback <function(): void>
})
```

Example

```lua
local Global_Setting = Window:GlobalSetting({
    Name = "Moderator Join Alerts",
    Default = false,
    Callback = function(State)
        print("Moderator Join Alerts " .. (State and "Enabled" or "Disabled"))
    end,
})
```



# Displaying a notification

MacLib gives you access to a built-in notification system, providing you with an easy way to display alerts and messages seamlessly within your UI.\
![](https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FKeel7meJL5sqEazbGjar%2Fimage.png?alt=media\&token=4384b1bf-2aba-44f1-80ad-c82f2a594a00)

```lua
Window:Notify({
    Title <string>
    Description <string>
    Lifetime <number>
    Scale <number>
    SizeX = <number>
    Style <string: "None", "Confirm", "Cancel"> -- The type of button that the user interacts with, input "None" for no interactable (or leave nil), input "Confirm" for a checkmark, and input "Cancel" for a crossmark.
    Callback <function(): void>
})
```

Functions

```lua
:UpdateTitle(<string>)
:UpdateDescription(<string>)
:Resize(<number>) -- Only X, Y is automatically determined by the content size
:Cancel()
```

Example

```lua
Window:Notify({
    Title = "Kuzu Hub",
    Description = "Hello, World!",
    Lifetime = 5
})
```




# Prompting a dialog

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2F142AClC7sOQoMgm4zAZP%2Fimage.png?alt=media&#x26;token=9b479aea-1a3b-4c0c-90c8-7012732c5080" alt=""><figcaption></figcaption></figure>

```lua
Window:Dialog({
    Title <string>
    Description <string>
    Buttons <table: <...table: Name, Callback>>
})
```

Functions

```lua
:UpdateTitle(<string>)
:UpdateDescription(<string>)
:Cancel()
```

Example

```lua
Window:Dialog({
    Title = "Kuzu Hub",
    Description = "Are you sure? This is not reversable and can get you banned in some up to date servers.",
    Buttons = {
        {
            Name = "Confirm",
            Callback = function()
            	print("Confirmed!")
            end,
        },
        {
            Name = "Cancel"
        }
    }
})
```




# Creating a tab group

Tab groups seperate different tabs into groups seperated by a divider.\
![](https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FDbWuvSBatvxBx4PLeLui%2Fimage.png?alt=media\&token=fc7b4124-08c0-4069-9931-1422d858c276)

```lua
local TabGroup = Window:TabGroup()
```




# Adding tabs

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FrOMDHXIfV8TQznGJyNAC%2Fimage.png?alt=media&#x26;token=4f9a1080-cacb-4aad-bb91-7d8b91777544" alt=""><figcaption></figcaption></figure>

```lua
local Tab = TabGroup:Tab({
  Name <string>
  Image <string> -- Image can be at maximum 16 pixels wide and 16 pixels tall.
})
```

Functions

```lua
:Select()
:InsertConfigSection(<string> Side)
```






# Adding sections

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FsFs2QLymn1hVQbwDy3JB%2Fimage.png?alt=media&#x26;token=5cc10089-cc2b-426a-8f45-728a099da94e" alt=""><figcaption></figcaption></figure>

```lua
local Section = Tab:Section({
  Side <string: "Left", "Right">
})
```





# Button

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FJ2rnCfAn4ESjEgC6kl2U%2Fimage.png?alt=media&#x26;token=df69d30f-6e9a-4a7d-bdcd-44ea1dbddd7a" alt=""><figcaption></figcaption></figure>

```lua
Section:Button({
  Name <string>
  Callback <function() void>
}, <string or nil> Flag)
```

Functions

```lua
:UpdateName(<string>)
:SetVisiblity(<boolean>)

.Settings : table -- Not everything may be updated, but Callback should be correct.
```

Example

```lua
sections.MainSection1:Button({
	Name = "Kill All",
	Callback = function()
		print("Killed everyone.")
	end,
})
```





# Input

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FsCTC6DnYd6q8yKDmiyIJ%2Fimage.png?alt=media&#x26;token=afaa15b6-f4c8-425e-8688-20b76006b2ee" alt=""><figcaption></figcaption></figure>

```lua
Section:Input({
  Name <string>
  Placeholder <string>
  AcceptedCharacters <function or string: "All", "Numeric", "Alphabetic", "AlphaNumeric">
  Callback <function(): string> -- Called upon focus lost
  onChanged <function(): string> -- Called upon text changed
}, <string or nil> Flag)
```

Functions

```lua
:UpdateName(<string>)
:SetVisiblity(<boolean>)
:GetInput(: string)
:UpdatePlaceholder(<string>)
:UpdateText(<string>)

.Text : string
.IgnoreConfig <boolean>
.Settings : table -- Not everything may be updated, but Callback should be correct.
```

Example

```lua
sections.MainSection1:Input({
	Name = "Target",
	Placeholder = "Username",
	AcceptedCharacters = "All",
	Callback = function(input)
		print("Target set: ".. input)
	end,
}, "TargetInput")
```

Example using custom AcceptedCharacters filter

```lua
sections.MainSection1:Input({
	Name = "Target",
	Placeholder = "Username",
	AcceptedCharacters = function(input)
		return input:gsub("[^a-zA-Z0-9]", "") -- AlphaNumeric sub
	end,
	Callback = function(input)
		print("Target set: ".. input)
	end,
}, "TargetInput")
```





# Slider

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FlnakspDGuWqy7xW9e7kf%2Fimage.png?alt=media&#x26;token=12b12bfc-acbf-455b-b481-791e85e23e73" alt=""><figcaption></figcaption></figure>

```lua
Section:Slider({
  Name <string>
  Default <number>
  Minimum <number>
  Maximum <number>
  DisplayMethod <string: "Round", "Degrees", "Percent", "Value">
  Precision <number>
  Callback <function(): number>
  onInputComplete <function(): number>
}, <string or nil> Flag)
```

Functions

```lua
:UpdateName(<string>)
:SetVisiblity(<boolean>)
:UpdateValue(<number>)
:GetValue(: number)

.Value : number
.IgnoreConfig <boolean>
.Settings : table -- Not everything may be updated, but Callback should be correct.
```

Example

```lua
sections.MainSection1:Slider({
	Name = "Walkspeed",
	Default = 16,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Percent",
	Callback = function(Value)
		print("Changed to ".. Value)
	end,
}, "WalkspeedSlider")
```






# Toggle

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FeI1i4HjiS7kQbALxauzV%2Fimage.png?alt=media&#x26;token=b40fa646-e2d6-41bb-8b98-d93c8dcefa54" alt=""><figcaption></figcaption></figure>

```lua
Section:Toggle({
  Name <string>
  Default <boolean>
  Callback <function(): boolean>
}, <string or nil> Flag)
```

Functions

```lua
:UpdateName(<string>)
:SetVisiblity(<boolean>)
:UpdateState(<boolean>)
:GetState(: boolean)

.State : boolean
.IgnoreConfig <boolean>
.Settings : table -- Not everything may be updated, but Callback should be correct.
```

Example

```lua
sections.MainSection1:Toggle({
	Name = "Flight",
	Default = false,
	Callback = function(value)
		Window:Notify({
			Title = "Kuzu Hub",
			Description = (value and "Enabled " or "Disabled ") .. "Flight"
		})
	end,
}, "FlightToggle")
```





# Keybind

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2F09OfuqpHiFw9s9P2N7ka%2Fimage.png?alt=media&#x26;token=7c098b49-5cd1-429a-8d0d-0f70a8c114bf" alt=""><figcaption></figcaption></figure>

```lua
Section:Keybind({
  Name <string>
  Default <enum>
  Blacklist <table: <... enum>> 
  Callback <function(): enum>
  onBinded <function(): enum>
  onBindHeld <function(): boolean, enum>
}, <string or nil> Flag)
```

Functions

```lua
:UpdateName(<string>)
:SetVisiblity(<boolean>)
:Unbind()
:Bind(<enum>)
:GetBind(: enum)

.Bind : enum
.IgnoreConfig <boolean>
.Settings : table -- Not everything may be updated, but Callback should be correct.
```

Example

```lua
sections.MainSection1:Keybind({
	Name = "Reset Inventory",
	Callback = function(binded)
		Window:Notify({
			Title = "Kuzu Hub",
			Description = "Successfully Reset Inventory",
			Lifetime = 3
		})
	end,
	onBinded = function(bind)
		Window:Notify({
			Title = "Kuzu Hub",
			Description = "Rebinded Reset Inventory to "..tostring(bind.Name),
			Lifetime = 3
		})
	end,
}, "ResetInventoryBind")
```






# Colorpicker

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FV1Fw3vj0z73KH6sxkW0L%2Fimage.png?alt=media&#x26;token=aeaeae37-1f80-4426-8c3e-d62cd9b2e1e9" alt=""><figcaption></figcaption></figure>

```lua
Section:Colorpicker({
  Name <string>
  Default <color3>
  Alpha <number or nil> -- Transparency
  Callback <function(): color3, number>
}, <string or nil> Flag)
```

Functions

```lua
:UpdateName(<string>)
:SetVisibility(<boolean>)
:SetColor(<color3>)
:SetAlpha(<number>)

.Color : color3
.Alpha : number
.IgnoreConfig <boolean>
.Settings : table -- Not everything may be updated, but Callback should be correct.
```

Example

```lua
sections.MainSection1:Colorpicker({
	Name = "ESP Color",
	Default = Color3.fromRGB(255,0,0),
	Alpha = 0,
	Callback = function(color, alpha)
		local r, g, b = math.round(color.R * 255), math.round(color.G * 255), math.round(color.B * 255)
		local formattedColor = string.format("%d, %d, %d", r, g, b)

		Window:Notify({
			Title = "Kuzu Hub",
			Description = string.format("Changed ESP Color\nColor: %s\nAlpha: %.2f", formattedColor, alpha),
			Lifetime = 3
		})
	end,
}, "ESPColorToggle")
```





# Dropdown

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FmxGIj0w2aTY5SSvc7rKe%2Fimage.png?alt=media&#x26;token=bba6dbca-dce8-4d2f-9ffe-678189ce3218" alt=""><figcaption></figcaption></figure>

```lua
Section:Dropdown({
  Name <string>
  Search <boolean> -- Enable searching?
  Multi <boolean> -- Allow multiple choices?
  Required <boolean> -- Force the user to select at minimum one choice?
  Options <table>
  Default <number or table> -- If Multi is enabled, you must input a table of every option name that you want enabled. If Multi is disabled you must input the order (index) in which the default option is at.
  Callback <function(): string or table> -- Multi Dropdowns return a table like such {"Option 1" = true, "Option 3" = true,} Single Dropdowns return the name (no table) of the selected option
}, <string or nil> Flag)
```

Functions

```lua
:UpdateName(<string>)
:SetVisiblity(<boolean>)
:UpdateSelection(<string or number or table>) -- string/number for single, table for multi
:InsertOptions(<table>)
:RemoveOptions(<table>)
:IsOption(<string>: boolean)
:GetOptions(: table) -- Returns a table of every option and if it's true or false (Example: {"Option 1" = true, "Option 2" = false, "Option 3" = false} etc..)
:ClearOptions()

.Value : string or table
.IgnoreConfig <boolean>
.Settings : table -- Not everything may be updated, but Callback should be correct.
```

Examples

```lua
sections.MainSection1:Dropdown({
	Name = "Give Weapons",
	Search = true,
	Multi = true,
	Required = false,
	Options = {"AK-47", "M4A1", "Desert Eagle", "AWP", "MP5", "SPAS-12"},
	Default = {"M4A1", "AWP"},
	Callback = function(Value)
		local Values = {}
		for _, State in next, Value do
			if State then
				table.insert(Values, _)
			end
		end
		print("Selected Weapons:", table.concat(Values, ", "))
	end,
}, "GiveWeaponsDropdown")
```








# Header

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2F7uzGoaSTmObF1KQD6w0O%2Fimage.png?alt=media&#x26;token=5380ce4a-ba3a-4bbd-9ed4-f44dc19e8394" alt=""><figcaption></figcaption></figure>

```lua
Section:Header({
  Text <string>
}, <string or nil> Flag)
```

Functions

```lua
:UpdateName(<string>)
:SetVisiblity(<boolean>)

.Settings : table -- Not everything may be updated, but Callback should be correct.
```





# Paragraph

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2F1uBiHmcZxFK80G0N3AFQ%2Fimage.png?alt=media&#x26;token=997dac03-7db3-43f7-b561-a1d69aed3941" alt=""><figcaption></figcaption></figure>

```lua
Section:Paragraph({
  Header <string>
  Body <string>
}, <string or nil> Flag)
```

Functions

```lua
:SetVisiblity(<boolean>)
:UpdateHeader(<string>)
:UpdateBody(<string>)

.Settings : table -- Not everything may be updated, but Callback should be correct.
```






# Label

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FuBjzpfZx1r0rAfL77lA4%2Fimage.png?alt=media&#x26;token=348d025b-df11-41db-b570-179da9ab3ce4" alt=""><figcaption></figcaption></figure>

```lua
Section:Label({
  Text <string>
}, <string or nil> Flag)
```

Functions

```lua
:UpdateName(<string>)
:SetVisiblity(<boolean>)

.Settings : table -- Not everything may be updated, but Callback should be correct.
```





# Sub Label

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FPBGI4a99csq4q6RIVs5n%2Fimage.png?alt=media&#x26;token=72337c07-5b7e-4536-9cde-1f55a228c75d" alt=""><figcaption></figcaption></figure>

```lua
Section:SubLabel({
  Text <string>
}, <string or nil> Flag)
```

Functions

```lua
:UpdateName(<string>)
:SetVisiblity(<boolean>)

.Settings : table -- Not everything may be updated, but Callback should be correct.
```






# Divider

<figure><img src="https://2943218207-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FhRtWRcExHV8IBJHoV9bx%2Fuploads%2FFFGXIGwJv1lMmf3BY6Eu%2Fimage.png?alt=media&#x26;token=cc07cd51-0339-42b2-a21a-1f8daa77baae" alt=""><figcaption></figcaption></figure>

```lua
Section:Divider()
```

Functions

```lua
:Remove()
:SetVisiblity(<boolean>)
```





# Spacer

```lua
Section:Spacer()
```

Functions

```lua
:Remove()
:SetVisiblity(<boolean>)
```
