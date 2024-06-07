import { mdiHandOkay, mdiTrashCan } from '@mdi/js'
import React, { useEffect, useState } from 'react'
import { Bib } from '../../interfaces'
import Button from '../Button'
import Buttons from '../Buttons'
import CardBoxModal from '../CardBox/Modal'

const TableSampleBibRegistrations = () => {
  const [bibs, setBibs] = useState<Bib[]>([])

  const fetchData = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/admin/getpendingbibs', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      })
      
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
  const [selectedBib, setSelectedBib] = useState(null)

  const handleUpdateAction = () => {
    setIsModalUpdateActive(false)
  }
  const handleTrashAction = () => {
    setIsModalTrashActive(false)
  }

  const handleDeleteAction = (name: string) => {
    setIsModalTrashActive(true)
    setSelectedBib(name)
  }
  const handleAcceptAction = (name: string) => {
    setIsModalUpdateActive(true)
    setSelectedBib(name)
  }

  const confirmDeleteAction = async () => {
    try {
      const response = await fetch(`http://localhost:3000/api/admin/rejectbib/${selectedBib}`, {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
      })

      if (!response.ok) {
        throw new Error('Failed to fetch data')
      }

      const data = await response.json()
      setBibs(data)
      setIsModalTrashActive(false)
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }

  const confirmAcceptAction = async () => {
    try {
      const response = await fetch(`http://localhost:3000/api/admin/acceptbib/${selectedBib}`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      })

      if (!response.ok) {
        throw new Error('Failed to fetch data')
      }

      const data = await response.json()
      setBibs(data)
      setIsModalUpdateActive(false)
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }

  return (
    <div className='mx-3'>
      <CardBoxModal
        title="Sample modal"
        buttonColor="info"
        buttonLabel="Done"
        isActive={isModalUpdateActive}
        onConfirm={confirmAcceptAction}
        onCancel={handleUpdateAction}
      >
        <p>
          Are you sure you want to confirm <b>accpeting this library to Kitaby?</b>
        </p>
      </CardBoxModal>

      <CardBoxModal
        title="Please confirm"
        buttonColor="danger"
        buttonLabel="Confirm"
        isActive={isModalTrashActive}
        onConfirm={confirmDeleteAction}
        onCancel={handleTrashAction}
      >
        <p>
          You are about to Decline this library's request <b>Are you sure?</b>
        </p>
      </CardBoxModal>

      <table className=''>
        <thead>
          <tr>
            <th />
            <th>Bib name</th>
            <th>Phone number</th>
            <th>Registre Commerciale</th>
            <th />
          </tr>
        </thead>
        <tbody>
          {bibsPaginated.map((bib: Bib, index) => (
            <tr key={bib.id}>
              <td className="border-b-0 lg:w-6 before:hidden">{index + 1}</td>
              <td data-label="bib Name">{bib.name}</td>
              <td data-label="Location">{bib.phone}</td>
              <td data-label="Q-Exchange" className="lg:w-1 whitespace-nowrap">
                {bib.com_reg_num}
              </td>
              <td className="before:hidden lg:w-1 whitespace-nowrap">
                <Buttons type="justify-start lg:justify-end" noWrap>
                  <Button
                    color="white"
                    icon={mdiHandOkay}
                    onClick={() => handleAcceptAction(bib.name)}
                  />
                  <Button
                    color="danger"
                    icon={mdiTrashCan}
                    onClick={() => handleDeleteAction(bib.name)}
                  />
                </Buttons>
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

export default TableSampleBibRegistrations;