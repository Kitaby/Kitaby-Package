import { mdiEye, mdiTrashCan } from '@mdi/js'
import React, { useEffect, useState } from 'react'
//import { useSamplebooks } from '../../hooks/sampleData'
import { Bib, Reservation } from '../../interfaces'
import Button from '../Button'
import Buttons from '../Buttons'
import CardBoxModal from '../CardBox/Modal'

const TableSampleBibs = () => {
  const [bibs, setBibs] = useState<Bib[]>([])

  const fetchData = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/admin/getbibs', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      })
      console.log(response);
      
      if (!response.ok) {
        throw new Error('Failed to fetch data')
      }

      const data = await response.json()
      setBibs(data)
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }
  useEffect(() => {
    fetchData()
  }, [])
    console.log(bibs);

  const perPage = 10
  const [currentPage, setCurrentPage] = useState(0)
  const bibsPaginated = bibs.slice(perPage * currentPage, perPage * (currentPage + 1))
  const numPages = Math.floor(bibs.length / perPage)+1
  const pagesList = []
  for (let i = 0; i < numPages; i++) {
    pagesList.push(i)
  }

  const [isModalUpdateActive, setIsModalUpdateActive] = useState(false)
  const [isModalTrashActive, setIsModalTrashActive] = useState(false)

  const handleUpdateAction = () => {
    setIsModalUpdateActive(false)
  }
  const handleTrashAction = () => {
    setIsModalTrashActive(false)
  }

  const handleDeleteUserAction = () => {}

  return (
    <div className='mx-3'>
      <CardBoxModal
        title="Sample modal"
        buttonColor="info"
        buttonLabel="Done"
        isActive={isModalUpdateActive}
        onConfirm={handleUpdateAction}
        onCancel={handleUpdateAction}
      >
        <p>
          Lorem ipsum dolor sit amet <b>adipiscing elit</b>
        </p>
        <p>This is sample modal</p>
      </CardBoxModal>

      <CardBoxModal
        title="Please confirm"
        buttonColor="danger"
        buttonLabel="Confirm"
        isActive={isModalTrashActive}
        onConfirm={handleTrashAction}
        onCancel={handleTrashAction}
      >
        <p>
          Lorem ipsum dolor sit amet <b>adipiscing elit</b>
        </p>
        <p>This is sample modal</p>
      </CardBoxModal>

      <table className=''>
        <thead>
          <tr>
            <th />
            <th>Bib name</th>
            <th>Location</th>
            <th>Quantity-reservation</th>
            <th>opening time</th>
            
          </tr>
        </thead>
        <tbody>
          {bibsPaginated.map((bib: Bib, index) => (
            <tr key={bib.id}>
              <td className="border-b-0 lg:w-6 before:hidden">{index + 1}</td>
              <td data-label="bib Name">{bib.name}</td>
              <td data-label="Location">{bib.address}</td>
              <td data-label="Q-Reservation" className="lg:w-1 whitespace-nowrap">
                {bib.reservations.length}
              </td>
              <td data-label="Q-Exchange" className="lg:w-1 whitespace-nowrap">
                {bib.openingHours? bib.openingHours : "9:00 AM - 5:00 PM"}
              </td>
              
              
            </tr>
          ))}
        </tbody>
      </table>

      {/*Pagination stuff */}
      <div className="p-3 lg:px-6 border-t border-gray-100 dark:border-slate-800">
        <div className="flex flex-col md:flex-row items-center justify-between py-3 md:py-0">
          <Buttons>
            {pagesList.map((page) => (
              <Button
                key={page}
                active={page === currentPage}
                label={page + 1}
                color={page === currentPage ? 'lightDark' : 'whiteDark'}
                small
                onClick={() => setCurrentPage(page)}
              />
            ))}
          </Buttons>
          <small className="mt-6 md:mt-0">
            Page {currentPage + 1} of {numPages}
          </small>
        </div>
      </div>
    </div>
  )
}

export default TableSampleBibs;
