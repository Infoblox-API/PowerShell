Remove-Variable -Name car1
Remove-Variable -Name car2

Enum ColorOfCar
{
    Red = 1
    Blue = 2
    Green = 3
}

Enum TypeOfCar
{
    Truck = 1
    SUV = 2
    Sedan = 3
}

Enum MakeOfCar
{
    Chevy = 1
    Ford = 2
    Olds = 3
    Toyota = 4
    BMW = 5
}

Class Vehicle
{
    [datetime]$year
    [String]$model
    [string]$make
    [ColorOfCar]$color
}

Class Car : Vehicle
{
    [int]$numberOfDoors
    [String]$vin
    [MakeOfCar] $make

    static [int]$numberOfWheels = 4
    hidden [int]$private:someCounter
    #note -private someCounter

    Car () {}

    Car ([string]$vin)
        {$this.vin = $vin}

    Car ([string]$vin, [string]$model)
        {$this.vin = $vin
        $this.model = $model}

    Car ([string]$vin, [string]$model, [datetime]$year)
        {$this.vin = $vin
        $this.model = $model
        $this.year = $year}

    Car ([string]$vin, [string]$model, [datetime]$year, [int]$numberOfDoors)
        {$this.vin = $vin
        $this.model = $model
        $this.year = $year
        $this.numberOfDoors = $numberOfDoors}

    [void]AddOne() {
        $this.someCounter ++
    }

}


$car1 = New-Object car
$car2 = [Car]::new()

$car1 | Format-Table
$car2 | Format-Table

Add-Member -InputObject $car1 -NotePropertyName "carType" -NotePropertyValue "Truck" -TypeName "TypeOfCar"
$car1.AddOne()

$car1 | Format-Table
$car2 | Format-Table

$car1.carType = "SUV"
$car1.color = "Red"
$car1 | Format-Table

$car1.color = 2
$car1 | Format-Table

# I would like to prevent this...I think
$car1.someCounter=5
$car1 | Format-Table

# Why does this destroy the object?
#Add-Member -InputObject $car1 -NotePropertyName "someInt" -NotePropertyValue ""     -TypeName "string"
#$car1 | Format-Table

